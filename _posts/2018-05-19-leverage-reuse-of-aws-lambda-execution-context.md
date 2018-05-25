---
layout: post
title: Improve Lambda performance by leveraging reuse of execution contexts
tags:
- AWS
- Lambda
- Serverless
- Performance
---

Properly reusing the execution contexts on AWS Lambda will reduce the execution time of your functions. Though this article illustrate the concept with Lambdas written in Java, the principle applies to any of the supported languages.

To understand what execution context reuse is, please consider the following lambda function:

```java
public class InstrumentedLambda implements RequestHandler<S3Event, String> {
    private static Logger logger;
    static {
        logger = LogManager.getLogger(InstrumentedLambda.class);
        logger.trace("Static initialization block");
    }
    {
        logger.trace("initialization block");
    }
    public InstrumentedLambda() {
        logger.trace("Constructor");
    }
    @Override
    public String handleRequest(S3Event input, Context context) {
        logger.trace("Handling request with " + this);
        return "done";
    }
}
```

Once published, and after three sequential invocations of the function – letting one second between each invocation – CloudWatch logs contains
and contains the following lines:

 ```
 InstrumentedLambda:15 - Static initialization block
 InstrumentedLambda:19 - Initialization block
 InstrumentedLambda:23 - Constructor
 START RequestId: 1c33abec-5b80-11e8-98bd-79ec2befa8f6 Version: $LATEST
 1c33abec-5b80-11e8-98bd-79ec2befa8f6 InstrumentedLambda:28 - Handling request with io.roudier.InstrumentedLambda@6321e813
 END RequestId: 1c33abec-5b80-11e8-98bd-79ec2befa8f6
 REPORT RequestId: 1c33abec-5b80-11e8-98bd-79ec2befa8f6    Duration: 493.38 ms    Billed Duration: 500 ms Memory Size: 512 MB    Max Memory Used: 64 MB
 START RequestId: 22de376c-5b80-11e8-b48b-db69832be13f Version: $LATEST
 22de376c-5b80-11e8-b48b-db69832be13f InstrumentedLambda:28 - Handling request with io.roudier.InstrumentedLambda@6321e813
 END RequestId: 22de376c-5b80-11e8-b48b-db69832be13f
 REPORT RequestId: 22de376c-5b80-11e8-b48b-db69832be13f    Duration: 40.03 ms    Billed Duration: 100 ms Memory Size: 512 MB    Max Memory Used: 64 MB
 START RequestId: 2366efc8-5b80-11e8-ac8e-797333ec52a2 Version: $LATEST
 2366efc8-5b80-11e8-ac8e-797333ec52a2 InstrumentedLambda:28 - Handling request with io.roudier.InstrumentedLambda@6321e813
 END RequestId: 2366efc8-5b80-11e8-ac8e-797333ec52a2
 REPORT RequestId: 2366efc8-5b80-11e8-ac8e-797333ec52a2    Duration: 4.11 ms    Billed Duration: 100 ms Memory Size: 512 MB    Max Memory Used: 65 MB
```

One can see that all the requests were served by the same instance of class InstrumentedLambda: `@6321e813`. Proof: Object.toString() uses Object.hashCode(), which typically converts the internal address of the object into an integer.

Digging deeper:
* When the first request arrives, an execution context is created; its id can be inferred from the log stream name: `2018/05/19/[$LATEST]ac9d0679f7ce4deab5ed6f13c3650d6f` -> `ac9d0679f7ce4deab5ed6f13c3650d6f`
* The InstrumentedLambda class is loaded by the Java runtime, as revealed by the log entry from the static initialization block
* The lambda platform instantiates the InstrumentedLambda class as shown by the log entry from initialization block and constructor
* The execution context becomes ready and only then is the request considered as starting
* The handleRequest method is called for each incoming request

So what happens to the execution context between each call?
* For some time, the execution context is frozen: all threads are paused, kind of like a GC stop-the-world
* When a new request arrives, the context is unfrozen and the handleRequest method is called
* If no requests arrives for a prolonged period of time (45 minutes or so), the execution context is destroyed
* Next time a request comes in, a new execution context is created

Now you have a better understanding of execution contexts reuse, you can easily figure out how to improve the performance of your lambdas:

> Perform costly initialization once, in the constructor or with singletons (or using static blocks), so that multiple calls to handleRequest(..) use the same connection pools, in-memory cache, etc.

To illustrate how initialization code can be refactored to leverage context reuse, please take a look at [this sample project on GitHub](https://github.com/proudier/lambda-execution-context-reuse). It's a S3 Event handler that applies some logic to update a NoSQL index.
* The poor implementation allocates resource every time they need it: see  [PoorLambda](https://raw.githubusercontent.com/proudier/lambda-execution-context-reuse/master/src/main/java/com/pierreroudier/lambda_execution_context_reuse/PoorLambda.java),  [PoorIndexImpl](https://raw.githubusercontent.com/proudier/lambda-execution-context-reuse/master/src/main/java/com/pierreroudier/lambda_execution_context_reuse/PoorIndexImpl.java) and the [execution log](https://raw.githubusercontent.com/proudier/lambda-execution-context-reuse/master/poor-lambda.log)
* The better implementation uses singletons to share connection to the NoSql index: see [BetterLambda](https://raw.githubusercontent.com/proudier/lambda-execution-context-reuse/master/src/main/java/com/pierreroudier/lambda_execution_context_reuse/BetterLambda.java),  [BetterIndexImpl](https://raw.githubusercontent.com/proudier/lambda-execution-context-reuse/master/src/main/java/com/pierreroudier/lambda_execution_context_reuse/BetterIndexImpl.java) and the [execution log](https://raw.githubusercontent.com/proudier/lambda-execution-context-reuse/master/better-lambda.log)

Let's compare performance:
* Cold starting an execution context take 720 ms with both implementations (which is the expected observation)
* Later invocation of the 'better' implementation is 46% faster than the 'poor' implementation: resp. 183,24 vs 99,53 ms (average over 3 invocations with 1 second let between each)

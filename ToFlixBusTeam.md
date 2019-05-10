# HTTPResponseParser
Dear FlixBus team,

Here i would want to explain myself in moving a bit away from the syntax proposed in the Home Assignment.

1. Swift is stronlgy typed language and it's hard do something with object of type Any
2. Making a server call i expect response with some structure. Even result can be different, message is optional, but structure of the payload is known when i make a request.
3. Result vs throws. Question of taste, for me Result provides more transparency keeping the possibility to continue a throw chain by calling result.get(). Typed errors are also adding clarity
4. XCTest don't have a default assert for thrown errors

In assignment you asked to provide user-friendly error messages. "The operation failed. Please try again later" doesn't really sound like this but i think better user experience can be reached by providing possible actions to solve the problem and presenting errors in nice way (custom views with cat shapes usually do well)

There's a lot of duplication code in unit tests which i'm sure is fine. Tests are testing the code but who can test tests? Usually, developer does, and to minimize the chance for mistake, i want to keep the tests code clear and readable.

Most of test cases were written for case when payload holds an object, but it's the same with a collection as long as they both confirm to Codable.

Thanks for your time and i would love to hear your feedback.

Cheers,
Nikita
  

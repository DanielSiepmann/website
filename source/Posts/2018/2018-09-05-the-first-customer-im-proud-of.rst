.. post:: Sep 05, 2018
   :tags: technical_dept, customer
   :excerpt: 2

Awesome customer
================

Since we founded our own Company `Codappix GmbH`_, we have a very different contact
with our customers. In our last companies we always were salaried employees and only
had contact to the customers through mail, in some small meetings and via support.

We now have the luck to get to know our customers very well, to understand their
needs and the way they had gone and want to go in the future. One of our customers is
very different from all other customers I’ve met so far. That’s why I want to write
about this customer. Everyone should know that such customers still exist and how fun
and motivating it is to work with them.

Everyone has the same problems
------------------------------

Nearly all customers in our area – the web – have the same main problems. Not enough
money and time, to much features and a old legacy code base with huge technical dept.

That’s why most people are happy if they do a re-launch instead of an update or
upgrade of a certain software, which in our case is TYPO3. Most might think »This
time we can make it better.« just to end up with the same as before.

How most customers tackle the problems
--------------------------------------

Badly most customers want it cheap and force agencies and freelancers to »just get the job
done«.

So Problems are not tackled at all by most customers.

What’s different with our customer?
-----------------------------------

Our customer has a setup like many others nowadays. A TYPO3 as content management
system and a Shopsystem. TYPO3 itself is not delivering anything itself to a visitor,
but provides content for the Shopsystem via an PHP Export. So all contents are
exported as PHP Files and included in the shop. This is not state of the art and
produces some errors, e.g. with single quotes.

So far no difference. Also both systems run for several years now and have a
technical dept base and not enough employees for TYPO3, still no difference.

The customer is aware of the technical dept and knows the pain for his employees to
live day by day with this depts. Also they are aware of costs resulting from the
depts, and how hard it is to implement new features or change certain parts of the
system.

Therefore they were looking for TYPO3 experts to help them to reduce the technical
dept. Also the expert should be a sparling partner for the employee. As there was
only one employee for TYPO3, there were no discussions and knowledge exchange.

What we have achieved so far
----------------------------

Thanks to all employees of our customer it was pretty easy to start with small steps
and to improve the environment first.

We started to integrate a CGL (=Coding Guideline) first. As everyone has his own
style to write code, we would have merge conflicts if different coders change a file.
So we first eliminated the extra time to resolve this unnecessary merge conflicts.

Right after this was introduced, we added pull requests to our workflow. They are
necessary to notify colleagues about changes and to discuss these changes. Are there
better ways to solve a certain problem? What are pros and cons of certain ways to
solve the problem or to write the code?

We started adding tests. First only small unit tests were added to kickstart
everything. But we added functional tests to test each content element and it’s
output, involving DataProcessors and ViewHelpers. This way we increased the benefit
of invested time. We could cover more features and code in less time. We also make
sure that a TYPO3 update would not break our output without our notice.

Also we would like to refactor the old code base in the future. Using small fine
grained unit tests would increase the time to write tests, and to adjust tests with
each refactoring. That’s why we go for functional tests in this area.

So far everything was on our local machines, there was no automation in place. We
decided to go with Bamboo and implemented our CGL and Tests within two days using
a custom Docker image with all necessary dependencies.

Now all pull requests will run all tests and CGL via Bamboo and we can focus on the
logic in our pull requests and discuss important parts, not CGL.

The result
----------

Employees are getting used to refactoring, as another one is checking the results
within a pull request. Also Bamboo runs all known tests and the author is informed if
something was broken.

Each employee does invest more time in solutions to come up with a better solution
then before. We do not want new technical debt, we want to reduce the existing one.
Also each change comes, if possible, with improvements to the existing code base, to
slowly reduce the existing technical debt during the daily business.

The best thing is not only how far we have come in half a year, but also how
everything started. Everyone involved was interested in the change and improvements.
There were no blocking situations. Everyone knows the pain and wants to reduce this
pain and prevent further pain.

Why does it work so well?
-------------------------

Not every customers fits every agency or freelancer. We all are humans with
individual goals. Some might find topics like state of the art frontend techniques
interesting, others project management. Every one involved in a project delivers the
best result if his tasks fit his skills and goals. Everyone is motivated by default,
but most companies demotivate their employees day by day.

Instead of forcing all employees to something, you have to accept that every employee
is an individual, your company has bigger goals but each employee has also small
goals for himself. You need to bring both together.

In our case everyone involved has the same goal, improve the code base, make it
easier to implement new features, and we all have a large common goal we are working
for. All the mentioned steps are only small goals on a way to a larger goal.

Our common goal is to exchange the current export of content from TYPO3 to the shop.
The current export has some nice concepts, but a bad code base, also PHP is not a
suited export format. By each step we took so far, we make it easier to change this
base in the future.

Once we change the format, we can change the expected output of content elements and
adjust the code base to produce this output.

How TYPO3 did his job
---------------------

If you take a look at the open source content management system `TYPO3`_, you will
see the same problems as discussed above. But TYPO3 began to tackle the technical
dept back in 2013.  Since then some core parts were refactored and now enable the
core team and further contributors to implement state of the art features.

That’s how TYPO3 tackles the problem, resolve them! They also tried to start freshly,
but that has divided to much. You will nearly never end up with a better version if
you start fresh. The key is to start right where you are and to improve step by step.

As we could see with our customer, this works pretty well. And TYPO3 is the proof of
this idea.

The customer is real
--------------------

Some parts might sound like a dream. But everything written so far is from real
world. The customer is real and everything happened as written above.

So go out, search for customers fitting your goals

.. _Codappix GmbH: https://codappix.com
.. _TYPO3: https://typo3.org

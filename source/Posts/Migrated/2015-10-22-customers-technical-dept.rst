.. post:: Oct 22, 2015
   :tags: customer, technical dept, development

Why not to be afraid of asking customers to pay for technical dept
==================================================================

An alternative name for this post could be: I definitely have to learn
to take less, or to be happy with less perfectly work. As I had to finish a new feature for one of
our customers today, while being at the TYPO3 conference in Amsterdam, I took a look at the time
tracking. This feature took five hours of time to be implemented. Everything he requested was to
implemented a Newsletter registration with double opt in for a lottery game. Of course the customer
already has a registration with double opt in for the newsletter. So the only task I had to do, was
to bring the information from lottery form to the newsletter. Sounds like a small deal and it
actually was. But where does the time come from?

Perhaps you already guessed, it's technical dept. The existing registration system wasn't designed
to get new subscribers from something else then the own web form. Also the validation of neither the
newsletter nor lottery web form did work as I expected. Not all necessary inputs were validated as
required. The output of error messages was not styled. And if you didn't insert a valid email
address to the newsletter subscription, all you get was a blank page.

If you're like me, that's definitely not what you expect. You want to have a form with all
validation rules, nice styled error messages. This way everything afterwards can rely on the input.

As I'm currently testing manually I've checked first my own implementation. As it worked, I tried
the old implementation, whether I broke anything. And all the mentioned issue occurred. So of course
I thought I broke everything. I checked it twice, checked the current version on live system and it
turns out, that's the current implementation.

So that's the first point where the technical debts occurred and procured extra time, which leads to
extra money someone has to spend.

But there is a second technical dept. I could not implement the transfer from one existing form to
the newsletter system as clean as I would. So it just works out for this one situation and was no
general solution.  But as there was no more time, the customer called us very late, I need to make a
decision. If the existing system was well designed, I could spend the extra time to implement my
solution the same way. But as there were broken windows (check out "*Don’t Live with Broken
Windows*" by `pragprog.com <https://pragprog.com/the-pragmatic-programmer/extracts/tips>`__), I
didn't have either the time, nor the motivation, blame on me. So we run into the circle where
technical dept creates even more technical dept.

So what's the conclusion?
-------------------------

I don't want to blame anyone, there are many reasons why you can get technical debts. But all you
can do is to try hard and make your work as good as you can. As soon as you encounter technical
debts, or broken windows, tell your boss, mate or customer. It's not all about you, you are in
charge to spread the work, and all together can find a solution.  Does the customer want to pay the
extra costs in the future? Does your mate care about the code base he has to work with too? How can
you reduce the technical debts and repair the broken windows?

But sometimes, perhaps the windows are not even broken. Perhaps you are looking through broken
glasses? In other words, perhaps you're the only one seeing the broken windows, perhaps it's a
problem for you, but no one else. If the customer is happy and everything works as he expects, it's
totally fine. For now ... Of course if you have higher claims that's good, because you have a reason
to keep going and improve. But always check reality and your personal opinion. What's most important
for now? What cares more at the moment?

    Working software over comprehensive documentation

It doesn't help if you implement the 110% solution, but can't finish soon enough and the customer
get into some trouble.

Of course, as everything else, it's just my very own, personal opinion.  So as with anything else
you read somewhere, check what fit for you.

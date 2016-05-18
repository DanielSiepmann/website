.. highlight:: ruby
.. post:: Aug 15, 2011
   :tags: php, sort, array, docs

Sorting a multidimensional array with array_multisort
=====================================================

| I often need to sort a multidimensional array for a specific value.
| As example let's say we have some stores with names and we want to
  sort them by name.

We first need the array we want to sort (here called ``arrayToSort``). Secondly we need a second
array containing the values we want to sort. In this case our names. I called the array
``arrayWithNamesToSort``.

::

    $arrayWithNamesToSort = array();
    $arrayToSort = array(
        array(
            "name" => "Store 3",
            "country" => "DE"
        ),
        array(
            "name" => "Store 1",
            "country" => "NL"
        ),
        array(
            "name" =>  "Store 2",
            "country" => "PL"
        )
    );

Now we need to fill in our name-values into the array *$arrayWithNamesToSort*.

::

    foreach ($arrayToSort as $arrayEntry) {
        $arrayWithNamesToSort[] = $arrayEntry["name"];
    }

Now we can easily use the function array\_multisort().  ``array_multisort($arrayWithNamesToSort,
$arrayToSort);`` The first parameter is our array, containing the values to sort. The second
parameter is our array we want to sort. PHP will sort the first array.  The second array will be
sort in the same way. So if the first value in the first array will become the third value, the
first value of the second array will become the third value too.

If we dump our array like the following, we will get this output:

::

    var_dump($arrayToSort);
    array_multisort($arrayWithNamesToSort, $arrayToSort);
    var_dump($arrayToSort);

::

    array
        0 =>
            array
                'name' => string 'Store 3' (length=7)
                'country' => string 'DE' (length=2)
        1 =>
            array
                'name' => string 'Store 1' (length=7)
                'country' => string 'NL' (length=2)
        2 =>
            array
                'name' => string 'Store 2' (length=7)
                'country' => string 'PL' (length=2)
    array
        0 =>
            array
                'name' => string 'Store 1' (length=7)
                'country' => string 'NL' (length=2)
        1 =>
            array
                'name' => string 'Store 2' (length=7)
                'country' => string 'PL' (length=2)
        2 =>
            array
                'name' => string 'Store 3' (length=7)
                'country' => string 'DE' (length=2)

Of course this is only a little easy example using the big function ``array_multisort()``, but
perhaps it will help some of you. There are of course many more ways to use this function.

Of course you can build a little function for the code I posted, this function can look like the
following:

::

    /**
     * Sorts a multidimensional array with deep one by a specified value.
     *
     * @param array  $arrayToSort The array you want to sort.
     * @param string $nameOfValue The name of the value you want to sort by.
     * @return array The sorted array.
     *
     * @author Daniel Siepmann < info@layne-obserdia.de >
     */
    function arrayMultisortByValue($arrayToSort, $nameOfValue) {
        $ValueContainer = array();
        foreach ($arrayToSort as $arrayEntry) {
            $ValueContainer[] = $arrayEntry[$nameOfValue];
        }
        array_multisort($ValueContainer, $arrayToSort);
        return $arrayToSort;
    }


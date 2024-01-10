
/**
* Your implementation of the Isogram exercise
*/
component {
	
    function isIsogram(input) {
		var check_word = arguments.input;
        var passed = false;

        sample_1 = replace(replace(check_word, "-", "", "all"), " ", "", "all");
        sample_2 = listToArray(sample_1, "", true);
        sample_3 = arrayToList(sample_2, ",");
        sample_4 = listRemoveDuplicates(sample_3, ",", true);
        sample_5 = replace(sample_4, ",", "", "all");

        if(sample_5 == sample_1){
            passed = true;
        }

        return passed;

	}
	
}
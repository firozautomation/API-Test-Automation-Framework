
function createTestData(sampleJson, fieldsToChange, numRecords) {
    var testData = [];

    for (var i = 0; i < numRecords; i++) {
        var copy = JSON.parse(JSON.stringify(sampleJson));

        fieldsToChange.forEach(function(fieldToChange) {
            copy[fieldToChange] = copy[fieldToChange] + i;
        });

        testData.push(copy);
    }



    return {content: testData};
}

var testData = {

  "country": "US",
  "taskStatusCode" : "Closed",
  "facilityCode" : "US_203532",

};

function getTestData() {

  String testData = JSON.stringify(createTestData(testData, ["taskStatusCode", "facilityCode"], 1), null, 1);

  console.log("all done getTestData()");
  console.log("test data: \n" + testData);

  return testData;
};


console.log("calling getTestData()");
getTestData();

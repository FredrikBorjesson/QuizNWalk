/**
 * Created by fredrik on 2017-12-05.
 */

const admin = require('./node_modules/firebase-admin');
const serviceAccount = require("./quisserver-firebase-adminsdk-oxu9y-c214b4a4c5.json");
var fs = require('fs');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://quisserver.firebaseio.com"
});

var db = admin.firestore();

var readQuiz = fs.readFileSync("dummyQuestions.json", 'utf8');
var quizJson = JSON.parse(readQuiz);

db.collection('quiz').doc('default').set(quizJson);

var readThumb = fs.readFileSync("quizThumb.json", 'utf8');
var thumbJson = JSON.parse(readThumb);

db.collection('quizThumb').doc('default').set(thumbJson);


console.log("Test test");

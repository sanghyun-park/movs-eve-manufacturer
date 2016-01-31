var express = require('express');
var router = express.Router();

// To process API request
var js2xmlparser = require("js2xmlparser");
var MongoClient = require('mongodb').MongoClient;
var assert = require('assert');
var url = 'mongodb://localhost:27017/eve-db';

/* EVE-DB APIs */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'API Supporting Portal' });
});

/* EVE SDE: blueprints.yaml */
router.get('/blueprints/:typeid', function(req, res, next) {
  // get typeid from url
  var typeid = parseInt(req.params.typeid);

  MongoClient.connect(url, function(err, db) {
    assert.equal(null, err);

    var collection = db.collection('blueprints');
    result = collection.find({"id": typeid});

    result.toArray(function (err, result) {
      if (err) {
        res.send(0);
      } else if (result.length) {
        res.set('Content-Type', 'text/xml');
        res.send(js2xmlparser("blueprint", result[0].data));
      } else {
        console.log(result);
        res.send(0);
      }

      db.close();
    });
  });
});

module.exports = router;

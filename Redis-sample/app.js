const REDIS_HOST_NAME = '172.22.2.109';
const REDIS_PORT_NO = 6379;
const redis = require('redis');

// 接続
let client = redis.createClient(REDIS_PORT_NO, REDIS_HOST_NAME);
client.on('connect', () => console.log('Redisに接続しました'));
client.on('error', err => console.log('次のエラーが発生しました：' + err));



let dataset = [
  { "value": 138 }
]
client.set("all-count", JSON.stringify(dataset[0]));

dataset = [
  { "id": "エリア1", "value": 24 },
  { "id": "エリア2", "value": 45 },
  { "id": "エリア3", "value": 3 },
  { "id": "エリア4", "value": 26 },
  { "id": "エリア5", "value": 8 },
  { "id": "エリア6", "value": 26 },
  { "id": "エリア7", "value": 8 },
  { "id": "エリア8", "value": 19 }
]
client.set("intrusion-count", JSON.stringify(dataset));

dataset = [
  { "id": "ライン1", "value": 24 },
  { "id": "ライン2", "value": 45 },
  { "id": "ライン3", "value": 3 },
  { "id": "ライン4", "value": 26 },
  { "id": "ライン5", "value": 8 },
  { "id": "ライン6", "value": 3 },
  { "id": "ライン7", "value": 26 },
  { "id": "ライン8", "value": 19 }
]
client.set("intersect-count", JSON.stringify(dataset));

dataset = [
  {"range":"2019-10-13 10:00:00", "value":0},
  {"range":"2019-10-13 11:00:00", "value":0},
  {"range":"2019-10-13 12:00:00", "value":0},
  {"range":"2019-10-13 13:00:00", "value":0},
  {"range":"2019-10-13 14:00:00", "value":170},
  {"range":"2019-10-13 15:00:00", "value":2572},
  {"range":"2019-10-13 16:00:00", "value":3997},
  {"range":"2019-10-13 17:00:00", "value":1297},
  {"range":"2019-10-14 10:00:00", "value":0},
  {"range":"2019-10-14 11:00:00", "value":0},
  {"range":"2019-10-14 12:00:00", "value":0},
  {"range":"2019-10-14 13:00:00", "value":0},
  {"range":"2019-10-14 14:00:00", "value":170},
  {"range":"2019-10-14 15:00:00", "value":2572},
  {"range":"2019-10-14 16:00:00", "value":3997},
  {"range":"2019-10-14 17:00:00", "value":1297},
  {"range":"2019-10-15 10:00:00", "value":0},
  {"range":"2019-10-15 11:00:00", "value":0},
  {"range":"2019-10-15 12:00:00", "value":0},
  {"range":"2019-10-15 13:00:00", "value":0},
  {"range":"2019-10-15 14:00:00", "value":170},
  {"range":"2019-10-15 15:00:00", "value":2572},
  {"range":"2019-10-15 16:00:00", "value":3997},
  {"range":"2019-10-15 17:00:00", "value":1297}
]
client.set("time-range-count", JSON.stringify(dataset));

dataset = [
  {"id": "AREA1", "range": "2019-10-13 10:00:00","value": "130"},
  {"id": "AREA2", "range": "2019-10-13 10:00:00","value": "121"},
  {"id": "AREA3", "range": "2019-10-13 10:00:00","value": "121"},
  {"id": "AREA4", "range": "2019-10-13 10:00:00","value": "121"},
  {"id": "AREA5", "range": "2019-10-13 10:00:00","value": "121"},
  {"id": "AREA6", "range": "2019-10-13 10:00:00","value": "121"},
  {"id": "AREA7", "range": "2019-10-13 10:00:00","value": "121"},
  {"id": "AREA8", "range": "2019-10-13 10:00:00","value": "121"},
  {"id": "AREA1", "range": "2019-10-13 11:00:00","value": "130"},
  {"id": "AREA2", "range": "2019-10-13 11:00:00","value": "121"},
  {"id": "AREA3", "range": "2019-10-13 11:00:00","value": "121"},
  {"id": "AREA4", "range": "2019-10-13 11:00:00","value": "121"},
  {"id": "AREA5", "range": "2019-10-13 11:00:00","value": "121"},
  {"id": "AREA6", "range": "2019-10-13 11:00:00","value": "121"},
  {"id": "AREA7", "range": "2019-10-13 11:00:00","value": "121"},
  {"id": "AREA8", "range": "2019-10-13 11:00:00","value": "121"},
  {"id": "AREA1", "range": "2019-10-13 12:00:00","value": "130"},
  {"id": "AREA2", "range": "2019-10-13 12:00:00","value": "121"},
  {"id": "AREA3", "range": "2019-10-13 12:00:00","value": "121"},
  {"id": "AREA4", "range": "2019-10-13 12:00:00","value": "121"},
  {"id": "AREA5", "range": "2019-10-13 12:00:00","value": "121"},
  {"id": "AREA6", "range": "2019-10-13 12:00:00","value": "121"},
  {"id": "AREA7", "range": "2019-10-13 12:00:00","value": "121"},
  {"id": "AREA8", "range": "2019-10-13 12:00:00","value": "121"}
]
client.set("time-range-intrusion-count", JSON.stringify(dataset));

dataset = [
  {"id": "ライン1", "range": "2019-10-13 10:00:00","value": "130"},
  {"id": "ライン2", "range": "2019-10-13 10:00:00","value": "121"},
  {"id": "ライン3", "range": "2019-10-13 10:00:00","value": "125"},
  {"id": "ライン4", "range": "2019-10-13 10:00:00","value": "130"},
  {"id": "ライン5", "range": "2019-10-13 10:00:00","value": "121"},
  {"id": "ライン6", "range": "2019-10-13 10:00:00","value": "125"},
  {"id": "ライン7", "range": "2019-10-13 10:00:00","value": "121"},
  {"id": "ライン8", "range": "2019-10-13 10:00:00","value": "125"},
  {"id": "ライン1", "range": "2019-10-13 11:00:00","value": "130"},
  {"id": "ライン2", "range": "2019-10-13 11:00:00","value": "121"},
  {"id": "ライン3", "range": "2019-10-13 11:00:00","value": "125"},
  {"id": "ライン4", "range": "2019-10-13 11:00:00","value": "130"},
  {"id": "ライン5", "range": "2019-10-13 11:00:00","value": "121"},
  {"id": "ライン6", "range": "2019-10-13 11:00:00","value": "125"},
  {"id": "ライン7", "range": "2019-10-13 11:00:00","value": "121"},
  {"id": "ライン8", "range": "2019-10-13 11:00:00","value": "125"},
  {"id": "ライン1", "range": "2019-10-13 12:00:00","value": "130"},
  {"id": "ライン2", "range": "2019-10-13 12:00:00","value": "121"},
  {"id": "ライン3", "range": "2019-10-13 12:00:00","value": "125"},
  {"id": "ライン4", "range": "2019-10-13 12:00:00","value": "130"},
  {"id": "ライン5", "range": "2019-10-13 12:00:00","value": "121"},
  {"id": "ライン6", "range": "2019-10-13 12:00:00","value": "125"},
  {"id": "ライン7", "range": "2019-10-13 12:00:00","value": "121"},
  {"id": "ライン8", "range": "2019-10-13 12:00:00","value": "125"}

]
client.set("time-range-intersect-count", JSON.stringify(dataset));



//Get
client.get('all-count', (err, reply) => {
  console.log(JSON.parse(reply));
});

client.get('intrusion-count', (err, reply) => {
  console.log(JSON.parse(reply));
});

client.get('intersect-count', (err, reply) => {
  console.log(JSON.parse(reply));
});

client.get('time-range-count', (err, reply) => {
  console.log(JSON.parse(reply));
});

client.get('time-range-intrusion-count', (err, reply) => {
  console.log(JSON.parse(reply));
});

client.get('time-range-intersect-count', (err, reply) => {
  console.log(JSON.parse(reply));
});



// 切断
client.quit()

// // 操作は基本的にRedisのコマンド名をそのまま使用
//

//
// // List
// client.rpush("list-key", "list-value1")
// client.rpush("list-key", "list-value2")
//
// // Set
// client.sadd("set-key", "set-value1")
// client.sadd("set-key", "set-value2")
//
// // Sortedset
// client.zadd("sortedset-key", 10, "value1")
// client.zadd("sortedset-key", 20, "value2")
//
// // Hash
// client.hset("hash-key", "member-name", "hash-value")
// client.hset("hash-key", "member-name2", "hash-value2")

class DemoJson{
  List<Map<String, dynamic>> demoJsonList = [
    //未成功连线
    {
      "msg": "Success",
      "resultMap": {
        "issue": "EG01_20240617172220091000051",
        "gameInfo": "SL_A004",
        "totalWinAmount": 0,
        "uuid": "80305bdb-adf7-45ce-8a31-f569ba403eba",
        "exStatus": 0,
        "betAmount": 100,
        "bonusCount": null,
        "cashBalance": 50000,
        "detail": [
          {
            "panel": [
              "W",
              "H1",
              "H2",
              "H3",
              "N1",
              "N2",
              "N3",
              "H1",
              "H1"
            ],
            "result": [],
            "ratio": 3
          }
        ],
        "viewOrderId": "EG01_20240617172220091000051",
        "status": 1
      },
      "resultCode": "000"
    },
    //成功连线
    {
      "msg": "Success",
      "resultMap": {
        "issue": "EG01_20240617172220091000052",
        "gameInfo": "SL_A004",
        "totalWinAmount": 31500,
        "uuid": "80305bdb-adf7-45ce-8a31-f569ba403eba",
        "exStatus": 0,
        "betAmount": 100,
        "bonusCount": null,
        "cashBalance": 1000,
        "detail": [
          {
            "panel": [
              "W",
              "W",
              "W",
              "H1",
              "H1",
              "H1",
              "H1",
              "H1",
              "H1"
            ],
            "result": [
              {
                "item": "W",
                "playResult": 7500,
                "line": 2,
                "linkCount": 3,
                "odd": 25
              },
              {
                "item": "H1",
                "playResult": 6000,
                "line": 1,
                "linkCount": 3,
                "odd": 20
              },
              {
                "item": "H1",
                "playResult": 6000,
                "line": 3,
                "linkCount": 3,
                "odd": 20
              },
              {
                "item": "H1",
                "playResult": 6000,
                "line": 4,
                "linkCount": 3,
                "odd": 20
              },
              {
                "item": "H1",
                "playResult": 6000,
                "line": 5,
                "linkCount": 3,
                "odd": 20
              }
            ],
            "ratio": 15
          }
        ],
        "viewOrderId": "EG01_20240617172220091000052",
        "status": 1
      },
      "resultCode": "000"
    }
  ];
}
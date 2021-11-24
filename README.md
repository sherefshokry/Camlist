# Camlist
Camlist iOS Engineer position's task using Clean Architecture Concepts with MVVM

### Installation

Dependencies in this project are provided via Cocoapods. Please install all dependencies with

`
pod install
`

## Use Cases

### Load Venue From Remote Use Case

#### Data:
- URL
- USER LOCATION 

#### Primary course (happy path):
1. Execute "Load Venue" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates venue from valid data.
5. System delivers venue list.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Venue Image Data From Remote Use Case

#### Data:
- URL
- VENUE ID

#### Primary course (happy path):
1. Execute "Load Venue Image Data" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers image data.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Venue From Cache Use Case

#### Primary course:
1. Execute "Load Venue" command with above data.
2. System retrieves venue data from cache.
3. System creates venue from cached data.
4. System delivers venue list.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path): 
1. System delivers no venues.

---

### Load Venue Image Data From Cache Use Case

#### Data:
- URL
- VENUE ID

#### Primary course (happy path):
1. Execute "Load Image Data" command with above data.
2. System retrieves data from the cache.
3. System delivers cached image data.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path):
1. System delivers not found error.

---

### Cache Venue Use Case

#### Data:
- Venue List

#### Primary course (happy path):
1. Execute "Save Venue List" command with above data.
2. System deletes old cache data.
3. System encodes Venue Image.
4. System timestamps the new cache.
5. System saves new cache data.
6. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.

---

### Cache Venue Image Data Use Case

#### Data:
- Venue Image
- Venue ID

#### Primary course (happy path):
1. Execute "Save Image Data" command with above data.
2. System caches image data.

#### Saving error course (sad path):
1. System delivers error.

---


## Flowchart

![Venue Loading Feature](venues_flowchart.png)


## Model Specs

### Venues

| Property      | Type                |
|---------------|---------------------|
| `id`          | `String`            |
| `name`        | `String`            |
| `location`    | `Location`          |


### Location 

| Property           | Type               |
|--------------------|--------------------|
| `address`          | `String`           |



### Place Photo

| Property      | Type                |
|---------------|---------------------|
| `id`          | `String`            |
| `prefix`      | `String`            |
| `suffix`      | `String`            |
| `width`       | `Int`               |
| `height`      | `Int`               |


### Payload contract

```
GET places/search

200 RESPONSE

{
   "results": [
            {
                "fsq_id": "52e5fdbb498e3e93281df168",
                "name": "Shahine Sq (ميدان شاهين)",
                "location": {
                   "address": "47 ش البطل احمد عبد العزيز تقاطع ش جامعة الدول العربية",
                   "country": "EG",
                   "cross_street": "El Batal Ahmed Abd El Aziz St",
                   "locality": "القاهرة",
                   "post_town": "المهندسين",
                   "postcode": "",
                   "region": "الجيزة"
                },
            }
            ...
	]
}
```

---

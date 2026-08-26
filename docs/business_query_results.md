# NorthStar Commerce — Business Query Results

This document contains the outputs from all 44 queries in sql/06_business_questions.sql, generated from the raw project data.

## 1.1 Total orders

```csv
total_orders
99441
```

## 1.2 Delivered orders

```csv
delivered_orders
96478
```

## 1.3 Total merchandise value

```csv
total_merchandise_value
13591643.70
```

## 1.4 Total freight value

```csv
total_freight_value
2251909.54
```

## 1.5 Average merchandise value per order

```csv
avg_merchandise_value_per_order
137.75
```

## 1.6 Unique actual customers who placed an order

```csv
unique_actual_customers
96096
```

## 2.1 Monthly merchandise value

```csv
order_month,merchandise_value
2016-09-01,267.36
2016-10-01,49507.66
2016-12-01,10.90
2017-01-01,120312.87
2017-02-01,247303.02
2017-03-01,374344.30
2017-04-01,359927.23
2017-05-01,506071.14
2017-06-01,433038.60
2017-07-01,498031.48
2017-08-01,573971.68
2017-09-01,624401.69
2017-10-01,664219.43
2017-11-01,1010271.37
2017-12-01,743914.17
2018-01-01,950030.36
2018-02-01,844178.71
2018-03-01,983213.44
2018-04-01,996647.75
2018-05-01,996517.68
2018-06-01,865124.31
2018-07-01,895507.22
2018-08-01,854686.33
2018-09-01,145.00
```

## 2.2 Month-over-month merchandise-value growth

```csv
order_month,merchandise_value,prior_month_value,month_over_month_growth_pct
2016-09-01,267.36,,
2016-10-01,49507.66,267.36,18417.23
2016-12-01,10.90,49507.66,-99.98
2017-01-01,120312.87,10.90,1103687.80
2017-02-01,247303.02,120312.87,105.55
2017-03-01,374344.30,247303.02,51.37
2017-04-01,359927.23,374344.30,-3.85
2017-05-01,506071.14,359927.23,40.60
2017-06-01,433038.60,506071.14,-14.43
2017-07-01,498031.48,433038.60,15.01
2017-08-01,573971.68,498031.48,15.25
2017-09-01,624401.69,573971.68,8.79
2017-10-01,664219.43,624401.69,6.38
2017-11-01,1010271.37,664219.43,52.10
2017-12-01,743914.17,1010271.37,-26.36
2018-01-01,950030.36,743914.17,27.71
2018-02-01,844178.71,950030.36,-11.14
2018-03-01,983213.44,844178.71,16.47
2018-04-01,996647.75,983213.44,1.37
2018-05-01,996517.68,996647.75,-0.01
2018-06-01,865124.31,996517.68,-13.19
2018-07-01,895507.22,865124.31,3.51
2018-08-01,854686.33,895507.22,-4.56
2018-09-01,145.00,854686.33,-99.98
```

## 2.3 Highest and lowest performing months

```csv
performance,order_month,merchandise_value
Highest,2017-11-01,1010271.37
Lowest,2016-12-01,10.90
```

## 3.1 One-time customers

```csv
one_time_customers
93099
```

## 3.2 Repeat customers

```csv
repeat_customers
2997
```

## 3.3 Repeat customer rate

```csv
repeat_customer_rate_pct
3.12
```

## 3.4 Highest number of orders placed by an actual customer

```csv
customer_unique_id,order_count
8d50f5eadf50201ccdcedfb9e2ac8455,17
```

## 3.5 Merchandise value by customer state

```csv
customer_state,merchandise_value
SP,5202955.05
RJ,1824092.67
MG,1585308.03
RS,750304.02
PR,683083.76
SC,520553.34
BA,511349.99
DF,302603.94
GO,294591.95
ES,275037.31
PE,262788.03
CE,227254.71
PA,178947.81
MT,156453.53
MA,119648.22
MS,116812.64
PB,115268.08
PI,86914.08
RN,83034.98
AL,80314.81
SE,58920.85
TO,49621.74
RO,46140.64
AM,22356.84
AC,15982.95
AP,13474.30
RR,7829.43
```

## 4.1 Categories by units sold

```csv
product_category,units_sold
bed_bath_table,11115
health_beauty,9670
sports_leisure,8641
furniture_decor,8334
computers_accessories,7827
housewares,6964
watches_gifts,5991
telephony,4545
garden_tools,4347
auto,4235
toys,4117
cool_stuff,3796
perfumery,3419
baby,3065
electronics,2767
stationery,2517
fashion_bags_accessories,2031
pet_shop,1947
office_furniture,1691
Uncategorized,1603
consoles_games,1137
luggage_accessories,1092
construction_tools_construction,929
home_appliances,771
musical_instruments,680
small_appliances,679
home_construction,604
books_general_interest,553
food,510
furniture_living_room,503
home_confort,434
drinks,379
audio,364
market_place,311
construction_tools_lights,304
air_conditioning,297
kitchen_dining_laundry_garden_furniture,281
food_drink,278
industry_commerce_and_business,268
books_technical,267
fixed_telephony,264
fashion_shoes,262
costruction_tools_garden,238
home_appliances_2,238
agro_industry_and_commerce,212
art,209
computers,203
signaling_and_security,199
construction_tools_safety,194
christmas_supplies,153
fashion_male_clothing,132
fashion_underwear_beach,131
furniture_bedroom,109
costruction_tools_tools,103
tablets_printing_image,83
small_appliances_home_oven_and_coffee,76
cine_photo,72
dvds_blu_ray,64
books_imported,60
fashio_female_clothing,48
party_supplies,43
diapers_and_hygiene,39
furniture_mattress_and_upholstery,38
music,38
flowers,33
fashion_sport,30
home_comfort_2,30
arts_and_craftmanship,24
portateis_cozinha_e_preparadores_de_alimentos,15
cds_dvds_musicals,14
la_cuisine,14
pc_gamer,9
fashion_childrens_clothes,8
security_and_services,2
```

## 4.2 Categories by merchandise value

```csv
product_category,merchandise_value
health_beauty,1258681.34
watches_gifts,1205005.68
bed_bath_table,1036988.68
sports_leisure,988048.97
computers_accessories,911954.32
furniture_decor,729762.49
cool_stuff,635290.85
housewares,632248.66
auto,592720.11
garden_tools,485256.46
toys,483946.60
baby,411764.89
perfumery,399124.87
telephony,323667.53
office_furniture,273960.70
stationery,230943.23
computers,222963.13
pet_shop,214315.41
musical_instruments,191498.88
small_appliances,190648.58
Uncategorized,179535.28
electronics,160246.74
consoles_games,157465.22
fashion_bags_accessories,152823.54
construction_tools_construction,144677.59
luggage_accessories,140429.98
home_appliances_2,113317.74
home_construction,83088.12
home_appliances,80171.53
agro_industry_and_commerce,72530.47
furniture_living_room,68916.56
fixed_telephony,59583.00
home_confort,58572.04
air_conditioning,55024.96
audio,50688.50
small_appliances_home_oven_and_coffee,47445.71
books_general_interest,46856.88
kitchen_dining_laundry_garden_furniture,46328.37
construction_tools_lights,41080.00
construction_tools_safety,40544.52
industry_commerce_and_business,39669.61
food,29393.41
market_place,28378.47
costruction_tools_garden,25715.89
art,24202.64
fashion_shoes,23562.77
drinks,22428.70
signaling_and_security,21509.23
furniture_bedroom,20028.78
books_technical,19096.06
costruction_tools_tools,15903.95
food_drink,15179.48
fashion_male_clothing,10797.82
fashion_underwear_beach,9541.55
christmas_supplies,8800.82
tablets_printing_image,7528.41
cine_photo,6933.46
music,6034.35
dvds_blu_ray,5999.39
books_imported,4639.85
party_supplies,4485.18
furniture_mattress_and_upholstery,4368.08
portateis_cozinha_e_preparadores_de_alimentos,3968.53
fashio_female_clothing,2803.64
fashion_sport,2119.51
la_cuisine,2054.99
arts_and_craftmanship,1814.01
diapers_and_hygiene,1567.59
pc_gamer,1545.95
flowers,1110.04
home_comfort_2,760.27
cds_dvds_musicals,730.00
fashion_childrens_clothes,569.85
security_and_services,283.29
```

## 4.3 Categories by number of orders

```csv
product_category,order_count
bed_bath_table,9417
health_beauty,8836
sports_leisure,7720
computers_accessories,6689
furniture_decor,6449
housewares,5884
watches_gifts,5624
telephony,4199
auto,3897
toys,3886
cool_stuff,3632
garden_tools,3518
perfumery,3162
baby,2885
electronics,2550
stationery,2311
fashion_bags_accessories,1864
pet_shop,1710
Uncategorized,1451
office_furniture,1273
consoles_games,1062
luggage_accessories,1034
home_appliances,764
construction_tools_construction,748
small_appliances,630
musical_instruments,628
books_general_interest,512
home_construction,490
food,450
furniture_living_room,422
home_confort,397
audio,350
drinks,297
market_place,280
books_technical,260
air_conditioning,253
kitchen_dining_laundry_garden_furniture,248
construction_tools_lights,244
fashion_shoes,240
industry_commerce_and_business,235
home_appliances_2,234
food_drink,227
fixed_telephony,217
art,202
costruction_tools_garden,194
agro_industry_and_commerce,182
computers,181
construction_tools_safety,167
signaling_and_security,140
christmas_supplies,128
fashion_underwear_beach,121
fashion_male_clothing,112
costruction_tools_tools,97
furniture_bedroom,95
tablets_printing_image,79
small_appliances_home_oven_and_coffee,75
cine_photo,65
dvds_blu_ray,59
books_imported,53
fashio_female_clothing,39
party_supplies,39
furniture_mattress_and_upholstery,38
music,38
flowers,29
diapers_and_hygiene,27
fashion_sport,27
home_comfort_2,24
arts_and_craftmanship,23
portateis_cozinha_e_preparadores_de_alimentos,14
la_cuisine,13
cds_dvds_musicals,12
fashion_childrens_clothes,8
pc_gamer,8
security_and_services,2
```

## 4.4 Average item price by category

```csv
product_category,avg_item_price,units_sold
computers,1098.34,203
small_appliances_home_oven_and_coffee,624.29,76
home_appliances_2,476.12,238
agro_industry_and_commerce,342.12,212
musical_instruments,281.62,680
small_appliances,280.78,679
portateis_cozinha_e_preparadores_de_alimentos,264.57,15
fixed_telephony,225.69,264
construction_tools_safety,208.99,194
watches_gifts,201.14,5991
air_conditioning,185.27,297
furniture_bedroom,183.75,109
pc_gamer,171.77,9
cool_stuff,167.36,3796
kitchen_dining_laundry_garden_furniture,164.87,281
office_furniture,162.01,1691
music,158.80,38
construction_tools_construction,155.73,929
costruction_tools_tools,154.41,103
industry_commerce_and_business,148.02,268
la_cuisine,146.79,14
security_and_services,141.65,2
auto,139.96,4235
audio,139.25,364
consoles_games,138.49,1137
home_construction,137.56,604
furniture_living_room,137.01,503
construction_tools_lights,135.13,304
home_confort,134.96,434
baby,134.34,3065
health_beauty,130.16,9670
luggage_accessories,128.60,1092
toys,117.55,4117
perfumery,116.74,3419
computers_accessories,116.51,7827
art,115.80,209
furniture_mattress_and_upholstery,114.95,38
sports_leisure,114.34,8641
Uncategorized,112.00,1603
garden_tools,111.63,4347
pet_shop,110.07,1947
signaling_and_security,108.09,199
costruction_tools_garden,108.05,238
party_supplies,104.31,43
home_appliances,103.98,771
cine_photo,96.30,72
dvds_blu_ray,93.74,64
bed_bath_table,93.30,11115
stationery,91.75,2517
market_place,91.25,311
housewares,90.79,6964
tablets_printing_image,90.70,83
fashion_shoes,89.93,262
furniture_decor,87.56,8334
books_general_interest,84.73,553
fashion_male_clothing,81.80,132
books_imported,77.33,60
arts_and_craftmanship,75.58,24
fashion_bags_accessories,75.25,2031
fashion_underwear_beach,72.84,131
books_technical,71.52,267
fashion_childrens_clothes,71.23,8
telephony,71.21,4545
fashion_sport,70.65,30
drinks,59.18,379
fashio_female_clothing,58.41,48
electronics,57.91,2767
food,57.63,510
christmas_supplies,57.52,153
food_drink,54.60,278
cds_dvds_musicals,52.14,14
diapers_and_hygiene,40.19,39
flowers,33.64,33
home_comfort_2,25.34,30
```

## 4.5 Top products by units sold

```csv
product_id,product_category,units_sold
aca2eb7d00ea1a7b8ebd4e68314663af,furniture_decor,527
99a4788cb24856965c36a24e339b6058,bed_bath_table,488
422879e10f46682990de24d770e7f83d,garden_tools,484
389d119b48cf3043d311335e499d9c6b,garden_tools,392
368c6c730842d78016ad823897a372db,garden_tools,388
53759a2ecddad2bb87a079a1f1519f73,garden_tools,373
d1c427060a0f73f6b889a5c7c61f2ac4,computers_accessories,343
53b36df67ebb7c41585e8d54d6772e08,watches_gifts,323
154e7e31ebfa092203795c972e5804a6,health_beauty,281
3dd2a17168ec895c781a9191c1e95ad7,computers_accessories,274
2b4609f8948be18874494203496bc318,health_beauty,260
7c1bd920dbdf22470b68bde975dd3ccf,health_beauty,231
a62e25e09e05e6faf31d90c6ec1aa3d1,watches_gifts,226
5a848e4ab52fd5445cdc07aab1c40e48,Uncategorized,197
bb50f2e236e5eea0100680137654686c,health_beauty,195
e0d64dcfaa3b6db5c54ca298ae101d05,watches_gifts,194
42a2c92a0979a949ca4ea89ec5c7b934,housewares,183
e53e557d5a159f5aa2c5e995dfdf244b,computers_accessories,183
b532349fe46b38fbc7bb3914c1bdae07,furniture_decor,169
35afc973633aaeb6b877ff57b2793310,home_confort,165
```

## 4.6 Top products by merchandise value

```csv
product_id,product_category,merchandise_value
bb50f2e236e5eea0100680137654686c,health_beauty,63885.00
6cdd53843498f92890544667809f1595,health_beauty,54730.20
d6160fb7873f184099d9bc95e30376af,computers,48899.34
d1c427060a0f73f6b889a5c7c61f2ac4,computers_accessories,47214.51
99a4788cb24856965c36a24e339b6058,bed_bath_table,43025.56
3dd2a17168ec895c781a9191c1e95ad7,computers_accessories,41082.60
25c38557cf793876c5abdd5931f922db,baby,38907.32
5f504b3a1c75b73d6151be81eb05bdc9,cool_stuff,37733.90
53b36df67ebb7c41585e8d54d6772e08,watches_gifts,37683.42
aca2eb7d00ea1a7b8ebd4e68314663af,furniture_decor,37608.90
e0d64dcfaa3b6db5c54ca298ae101d05,watches_gifts,31786.82
d285360f29ac7fd97640bf0baef03de0,watches_gifts,31623.81
7a10781637204d8d10485c71a6108a2e,watches_gifts,30467.50
f1c7f353075ce59d8a6f3cf58f419c9c,bed_bath_table,29997.36
f819f0c84a64f02d3a5606ca95edd272,watches_gifts,29024.48
588531f8ec37e7d5ff5b7b22ea0488f8,computers,28291.99
422879e10f46682990de24d770e7f83d,garden_tools,26577.22
16c4e87b98a9370a9cbc3a4658a3f45b,musical_instruments,25034.00
5a848e4ab52fd5445cdc07aab1c40e48,Uncategorized,24229.03
a62e25e09e05e6faf31d90c6ec1aa3d1,watches_gifts,24051.00
```

## 4.7 Unsold products

```csv
unsold_products
0
```

## 4.8 Freight-to-price ratio by category

```csv
product_category,freight_to_price_ratio,freight_to_price_pct
home_comfort_2,0.5397,53.97
flowers,0.4404,44.04
furniture_mattress_and_upholstery,0.3733,37.33
christmas_supplies,0.3669,36.69
diapers_and_hygiene,0.3660,36.60
cds_dvds_musicals,0.3082,30.82
signaling_and_security,0.3026,30.26
food_drink,0.2970,29.70
electronics,0.2907,29.07
fashion_sport,0.2728,27.28
furniture_living_room,0.2607,26.07
kitchen_dining_laundry_garden_furniture,0.2590,25.90
drinks,0.2560,25.60
office_furniture,0.2503,25.03
food,0.2474,24.74
furniture_decor,0.2367,23.67
furniture_bedroom,0.2313,23.13
housewares,0.2312,23.12
books_technical,0.2243,22.43
fashio_female_clothing,0.2218,22.18
telephony,0.2200,22.00
luggage_accessories,0.2168,21.68
dvds_blu_ray,0.2148,21.48
fashion_shoes,0.2088,20.88
costruction_tools_garden,0.2065,20.65
fashion_bags_accessories,0.2058,20.58
arts_and_craftmanship,0.2040,20.40
garden_tools,0.2039,20.39
stationery,0.2026,20.26
fashion_underwear_beach,0.2008,20.08
fashion_male_clothing,0.1993,19.93
industry_commerce_and_business,0.1988,19.88
bed_bath_table,0.1974,19.74
books_general_interest,0.1962,19.62
market_place,0.1923,19.23
home_appliances,0.1848,18.48
construction_tools_lights,0.1846,18.46
party_supplies,0.1846,18.46
pet_shop,0.1846,18.46
cine_photo,0.1812,18.12
sports_leisure,0.1706,17.06
fashion_childrens_clothes,0.1676,16.76
art,0.1671,16.71
home_construction,0.1665,16.65
baby,0.1660,16.60
books_imported,0.1659,16.59
tablets_printing_image,0.1629,16.29
la_cuisine,0.1623,16.23
computers_accessories,0.1615,16.15
toys,0.1600,16.00
Uncategorized,0.1569,15.69
auto,0.1563,15.63
security_and_services,0.1455,14.55
home_confort,0.1451,14.51
health_beauty,0.1450,14.50
construction_tools_construction,0.1427,14.27
perfumery,0.1358,13.58
cool_stuff,0.1323,13.23
costruction_tools_tools,0.1277,12.77
consoles_games,0.1259,12.59
air_conditioning,0.1227,12.27
music,0.1144,11.44
audio,0.1127,11.27
musical_instruments,0.0973,9.73
construction_tools_safety,0.0967,9.67
home_appliances_2,0.0935,9.35
pc_gamer,0.0864,8.64
small_appliances,0.0840,8.40
watches_gifts,0.0834,8.34
agro_industry_and_commerce,0.0806,8.06
portateis_cozinha_e_preparadores_de_alimentos,0.0781,7.81
fixed_telephony,0.0778,7.78
small_appliances_home_oven_and_coffee,0.0579,5.79
computers,0.0441,4.41
```

## 5.1 Payment type share

```csv
payment_type,payment_record_count,payment_record_share_pct
credit_card,76795,73.92
boleto,19784,19.04
voucher,5775,5.56
debit_card,1529,1.47
not_defined,3,0.00
```

## 5.2 Total and average payment value by type

```csv
payment_type,total_payment_value,avg_payment_value
credit_card,12542084.19,163.32
boleto,2869361.27,145.03
voucher,379436.87,65.70
debit_card,217989.79,142.57
not_defined,0.00,0.00
```

## 5.3 Orders with multiple payment records

```csv
orders_with_multiple_payment_records
2961
```

## 5.4 Orders with multiple payment types

```csv
orders_with_multiple_payment_types
2246
```

## 5.5 Average valid credit-card installments

```csv
avg_credit_card_installments
3.51
```

## 5.6 Valid credit-card installment distribution

```csv
payment_installments,payment_record_count,payment_record_share_pct
1,25455,33.15
2,12413,16.16
3,10461,13.62
4,7098,9.24
10,5328,6.94
5,5239,6.82
8,4268,5.56
6,3920,5.10
7,1626,2.12
9,644,0.84
12,133,0.17
15,74,0.10
18,27,0.04
11,23,0.03
24,18,0.02
20,17,0.02
13,16,0.02
14,15,0.02
17,8,0.01
16,5,0.01
21,3,0.00
22,1,0.00
23,1,0.00
```

## 6.1 Delivered, canceled, unavailable, and incomplete percentages

```csv
status_group,order_count,order_share_pct
delivered,96478,97.02
incomplete,1729,1.74
canceled,625,0.63
unavailable,609,0.61
```

## 6.2 Monthly cancellation rate

```csv
order_month,total_orders,canceled_orders,cancellation_rate_pct
2016-09-01,4,2,50.00
2016-10-01,324,24,7.41
2016-12-01,1,0,0.00
2017-01-01,800,3,0.38
2017-02-01,1780,17,0.96
2017-03-01,2682,33,1.23
2017-04-01,2404,18,0.75
2017-05-01,3700,29,0.78
2017-06-01,3245,16,0.49
2017-07-01,4026,28,0.70
2017-08-01,4331,27,0.62
2017-09-01,4285,20,0.47
2017-10-01,4631,26,0.56
2017-11-01,7544,37,0.49
2017-12-01,5673,11,0.19
2018-01-01,7269,34,0.47
2018-02-01,6728,73,1.09
2018-03-01,7211,26,0.36
2018-04-01,6939,15,0.22
2018-05-01,6873,24,0.35
2018-06-01,6167,18,0.29
2018-07-01,6292,41,0.65
2018-08-01,6512,84,1.29
2018-09-01,16,15,93.75
2018-10-01,4,4,100.00
```

## 6.3 Cancellation rate by state (minimum 100 orders)

```csv
customer_state,total_orders,canceled_orders,cancellation_rate_pct
RO,253,3,1.19
PI,495,4,0.81
SP,41746,327,0.78
RJ,12852,86,0.67
GO,2020,13,0.64
MG,11635,64,0.55
MA,747,4,0.54
SC,3637,19,0.52
CE,1336,7,0.52
BA,3380,16,0.47
RS,5466,25,0.46
PR,5045,22,0.44
ES,2033,9,0.44
PA,975,4,0.41
PB,536,2,0.37
TO,280,1,0.36
DF,2140,7,0.33
PE,1652,5,0.30
SE,350,1,0.29
MS,715,2,0.28
AL,413,1,0.24
MT,907,2,0.22
RN,485,0,0.00
AM,148,0,0.00
```

## 7.1 Average purchase-to-approval time

```csv
avg_purchase_to_approval_hours
10.42
```

## 7.2 Average purchase-to-carrier time

```csv
avg_purchase_to_carrier_hours
77.79
```

## 7.3 Average carrier-to-customer time

```csv
avg_carrier_to_customer_days
9.33
```

## 7.4 Average and median total delivery time

```csv
avg_delivery_days,median_delivery_days
12.56,10.22
```

## 7.5 On-time delivery rate

```csv
eligible_orders,on_time_orders,on_time_delivery_rate_pct
96470,88644,91.89
```

## 7.6 Late orders

```csv
late_orders
7826
```

## 7.7 Average days early and average days late

```csv
avg_days_early,avg_days_late
13.01,9.55
```

## 7.8 Average delivery time by state

```csv
customer_state,delivered_orders,avg_delivery_days
RR,41,29.39
AP,67,27.19
AM,145,26.43
AL,397,24.54
PA,946,23.77
MA,717,21.57
SE,335,21.52
CE,1279,21.27
AC,80,21.04
PB,517,20.43
PI,476,19.46
RO,243,19.37
BA,3256,19.34
RN,474,19.28
PE,1593,18.45
MT,886,18.06
TO,274,17.66
ES,1995,15.79
MS,701,15.62
GO,1957,15.61
RJ,12350,15.31
RS,5344,15.30
SC,3546,14.95
DF,2080,12.97
MG,11354,12.01
PR,4923,11.99
SP,40494,8.76
```

## 7.9 On-time delivery rate by state (minimum 100 eligible orders)

```csv
customer_state,eligible_orders,on_time_orders,on_time_delivery_rate_pct
AL,397,302,76.07
MA,717,576,80.33
PI,476,400,84.03
CE,1279,1083,84.68
SE,335,284,84.78
BA,3256,2799,85.96
RJ,12350,10686,86.53
TO,274,239,87.23
PA,946,829,87.63
ES,1995,1751,87.77
MS,701,620,88.45
PB,517,460,88.97
PE,1593,1421,89.20
RN,474,423,89.24
SC,3546,3200,90.24
GO,1957,1797,91.82
RS,5344,4962,92.85
DF,2080,1933,92.93
MT,886,826,93.23
SP,40494,38107,94.11
MG,11354,10717,94.39
PR,4923,4677,95.00
AM,145,139,95.86
RO,243,236,97.12
```

## 7.10 Delivery performance over time

```csv
order_month,eligible_orders,avg_delivery_days,on_time_delivery_rate_pct
2016-09-01,1,54.81,0.00
2016-10-01,265,19.60,98.87
2016-12-01,1,4.69,100.00
2017-01-01,750,12.65,96.93
2017-02-01,1653,13.17,96.79
2017-03-01,2546,12.95,94.42
2017-04-01,2303,14.92,92.14
2017-05-01,3545,11.32,96.39
2017-06-01,3135,12.01,96.14
2017-07-01,3872,11.59,96.57
2017-08-01,4193,11.15,96.68
2017-09-01,4150,11.85,94.80
2017-10-01,4478,11.86,94.71
2017-11-01,7288,15.16,85.69
2017-12-01,5513,15.39,91.62
2018-01-01,7069,14.08,93.44
2018-02-01,6555,16.95,84.01
2018-03-01,7003,16.30,78.64
2018-04-01,6798,11.50,94.69
2018-05-01,6749,11.42,91.76
2018-06-01,6096,9.24,98.64
2018-07-01,6156,8.96,95.52
2018-08-01,6351,7.73,89.61
```

## 8.1 Total payment value versus total item price plus freight

```csv
total_payment_value,total_item_and_freight_value,payment_minus_item_and_freight
16008872.12,15843553.24,165318.88
```

## 8.2 Matching versus nonmatching orders (one-cent tolerance)

```csv
comparable_orders,matching_orders,nonmatching_orders
98665,98362,303
```

## 8.3 Largest order-level reconciliation differences

```csv
order_id,payment_value,item_and_freight_value,difference,absolute_difference
ce6d150fb29ada17d2082f4847107665,1586.47,1403.66,182.81,182.81
6e5fe7366a2e1bfbf3257dba0af1267f,406.92,287.91,119.01,119.01
70b742795bc441e94a44a084b6d9ce7a,578.82,466.93,111.89,111.89
996c7e73600ad3723e8627ab7bef81e4,664.43,587.90,76.53,76.53
70b7e94ea46d3e8b5bc12a50186edaf0,274.84,213.15,61.69,61.69
bc2c82b0ef78d2252b6176d1972db7c9,303.02,242.01,61.01,61.01
af9ffff2ce6b3defd34fd4c78857a379,466.97,413.17,53.80,53.80
262118ce178bb3e4590a3adcf6d62e6b,126.12,177.74,-51.62,51.62
bfdb5bbb06458d600a33d61f5f287472,394.36,348.93,45.43,45.43
8d9c0dc8d5a2ce804f6b925d8f8e6c1d,293.89,254.45,39.44,39.44
b7579d24f5b2dd3e20f2e57d0e07d170,504.37,466.28,38.09,38.09
abf1130bc676c9dcadf91e24f5e30a30,496.89,459.36,37.53,37.53
b76190a2c095fba255ab46987545a660,263.24,227.91,35.33,35.33
32720c0c8b42f4c2cdb07cee5ec2444b,259.59,224.75,34.84,34.84
6b0ac1bdea322c7060eea92feb9e9a6f,362.56,327.87,34.69,34.69
ee9dfabed586581a184f72e03544b4a2,342.12,307.50,34.62,34.62
e8295bee3fcc58cbd94f165f36c11f4b,151.93,117.85,34.08,34.08
dd7a24d1088cf9ed90329fb0dee088f4,293.07,259.31,33.76,33.76
a69aaa894f707814637e9794aa556f0f,211.87,179.35,32.52,32.52
513a94a0164453b4777d125b836f7ca1,240.47,208.19,32.28,32.28
```

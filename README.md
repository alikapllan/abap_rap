# ABAP RAP Learning
All changes have been committed one by one, so the change flow can be tracked in [commits](https://github.com/alikapllan/abap_rap/commits/main/).

## To-Do for Testing in your system 
1. Create Database tables (if not created automatically after pulling the repo using ABAPGit)
2. Run the Data Load Class within the related Package in Eclipse ADT as 'ABAP Application (Console)'. Then you will have mock data.
3. Now in Service Binding you can call the app in preview and play on it.

## RAP CRUD Syntax
[Create](https://github.com/alikapllan/abap_rap/blob/main/src/zahk_rap_crud_syntax/zcl_rapdemo02_crud_syntax.clas.abap#L23-L102)  
[Read](https://github.com/alikapllan/abap_rap/blob/main/src/zahk_rap_crud_syntax/zcl_rapdemo02_crud_syntax.clas.abap#L136-L177)    
[Update](https://github.com/alikapllan/abap_rap/blob/main/src/zahk_rap_crud_syntax/zcl_rapdemo02_crud_syntax.clas.abap#L179-L226)     
[Delete](https://github.com/alikapllan/abap_rap/blob/main/src/zahk_rap_crud_syntax/zcl_rapdemo02_crud_syntax.clas.abap#L104-L134)  
## [Managed Scenario Example](https://github.com/alikapllan/abap_rap/tree/main/src/zahk_rap_managed/zahk_rap_managed_01) 
### Overview of Development Package of this Example
-> Some parts might be unnecessary or even missing( me a junior and still learning :') ). But I just wanted to add it so you can at least see what kind of a development structure in package it has.  
![image](https://github.com/user-attachments/assets/6229aa80-6f96-48c2-ad40-4a94e2bb60fd)  
## [Managed Scenario Example 2](https://github.com/alikapllan/abap_rap/tree/main/src/zahk_rap_managed/zahk_rap_google_translate)
This Managed Scenario Example 2 - Translation App is replicated from [a blog of SoftwareHeroes.com](https://software-heroes.com/en/blog/abap-rap-translate-app-example). The development flow is explained in this blog very well also using [ADT RAP Generator Wizard](https://discoveringabap.com/2022/11/16/abap-restful-application-programming-model-8-rap-generator-wizard/). 
## [Unmanaged Scenario Example](https://github.com/alikapllan/abap_rap/tree/main/src/zahk_rap_unmanaged/zahk_rap_unmanaged_01) 

## Development Flow of RAP
#### All of the Following Screenshots are taken from [SAP Learning -> Course Building Apps with the ABAP RESTful Application Programming Model](https://learning.sap.com/courses/building-apps-with-the-abap-restful-application-programming-model/the-enhanced-business-scenario_LE_1a4a9cd8-d068-4613-95ef-ef05ddf0b3ce)
![image](https://github.com/user-attachments/assets/f852ada8-ca2b-4b97-8f98-9ae215349686)  

### Business Object
#### [--> source <--](https://d.dam.sap.com/a/SGYW5Us/20240611_ABAP_RAP_Overview%40SCN.pdf?inline=true&rc=10&doi=SAP1085541)  

![image](https://github.com/user-attachments/assets/632f049b-3a2d-47e6-92c1-a12c2523e897)

### Managed Business Object Runtime Implementation
![image](https://github.com/user-attachments/assets/62750c1b-cc43-4cdf-b3f0-4cedf97d027e)

### Unmanaged Business Object Runtime Implementation
![image](https://github.com/user-attachments/assets/42b1631b-ed6b-4a0f-86cd-dd784e11cf47)

## Troubleshooting of SAP Fiori App
#### Following Screenshots are taken from [SAP Learning -> Course Building Apps with the ABAP RESTful Application Programming Model -> Troubleshooting your SAP Fiori App](https://learning.sap.com/courses/building-apps-with-the-abap-restful-application-programming-model/troubleshooting-your-sap-fiori-app_LE_a174358d-4fa9-492b-864b-a276c28e80ec)
![image](https://github.com/user-attachments/assets/dba7295a-20e2-4e7a-9da4-ef9eb67ea7b3)
![image](https://github.com/user-attachments/assets/b552caa8-13b2-4790-9731-cfd1bcd8a486)

## [Dealing with Existing Code](https://learning.sap.com/courses/building-apps-with-the-abap-restful-application-programming-model/defining-and-implementing-the-business-object-behavior_LE_3903d34c-9c78-4089-b967-bcdf1581a135)

## [Service Consumption & Web APIs](https://learning.sap.com/courses/building-apps-with-the-abap-restful-application-programming-model/the-business-scenario_LE_154dc8cd-c3e4-4939-b8b0-8b0b1b326395)

## Youtube Channel - SAP Developers - Useful Video resources
[01 - ABAP Cloud - Expose ABAP CDS view using Communication Arrangement](https://www.youtube.com/watch?v=3QoP-6cTDm4&ab_channel=SAPDevelopers)  
[02 - ABAP Cloud - Create your First App using RAP Generator](https://www.youtube.com/watch?v=-SMAfDdPmeo)  
[03 - ABAP Cloud - Fiori project using ABAP Tool Bridge](https://www.youtube.com/watch?v=vwcTSPH84GY)  

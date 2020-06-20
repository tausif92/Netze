*** Settings ***
Library             Selenium2Library
Library             DateTime
Library             String
Resource            TestData.robot
Resource            Keywords.robot

*** Test Cases ***
TC1: User settings
    [Tags]   TC1
    Login
    Click Logo
    Wait And Click   //button[@id="closeFilterPanel"]    5
    Edit User Settings
    Logout
    Login
    Check Selected Tab

TC2: Check Vorgangs-Nr
    [Tags]   TC2
    Login
    Click Logo
    ${TodaysDate}    Get Todays Date
    Select Date    ${TodaysDate}    ${TodaysDate}
    Wait And Click    //button[@id="applyFilter"]
    Wait And Click    //a[text()="Baumaßnahmen"]
    ${Vorgangs-Nr_FromList}    Get First Vorgangs-Nr
    Filter Vorgangs-Nr   ${Vorgangs-Nr_FromList}    Vorgangs-Nr
    ${Vorgangs-Nr_FromDetails}    Get Vorgangs-Nr From Details
    Run Keyword If    "${Vorgangs-Nr_FromList}"=="${Vorgangs-Nr_FromDetails}"    Log    Passed :: Vorgangs-Nr from the list and from the details are matching.
    ...   ELSE    Fail    Failed :: Vorgangs-Nr from the list and from the details are not matching.

TC3: Check Zug-Nr
    [Tags]   TC3
    Login
    Click Logo
    ${TodaysDate}    Get Todays Date
    Select Date    ${TodaysDate}    ${TodaysDate}
    Wait And Click    //button[@id="applyFilter"]
    Wait And Click    //a[text()="Laufwege"]
    ${Zug-Nr_FromList}    Get First Train-Nr
    Filter Train-Nr       ${Zug-Nr_FromList}    Zug-Nr
    ${Zug-Nr_FromDetails}    Get Train-Nr From Details
    Run Keyword If    "${Zug-Nr_FromList}"=="${Zug-Nr_FromDetails}"    Log    Passed :: Zug-Nr from the list and from the details are matching.
    ...   ELSE    Fail    Failed :: Zug-Nr from the list and from the details are not matching.

TC4: Check Betriebsstelle
    [Tags]   TC4
    Login
    Click Logo
    Filter Betriebsstelle    ${Betriebsstelle}    ${Betriebsstelle_Option}
    Wait And Click    //a[text()="Laufwege"]
    Check Betriebsstelle     ${Betriebsstelle}

*** Keywords ***
Filter Betriebsstelle
    [Arguments]   ${Betriebsstelle}    ${Betriebsstelle_Option}
    Wait And Input   //input[@id="bst-0"]    ${Betriebsstelle}
    Wait Until Element Is Visible     //*[text()="${Betriebsstelle_Option}"]    5
    Wait And Click    //*[text()="AA (Hamburg-Altona)"]
    Capture Page Screenshot
    Wait And Click    //button[@id="applyFilter"]

Check Betriebsstelle
    [Arguments]   ${Betriebsstelle}
    Wait And Click     (//button[@aria-label="Expand"])[1]
    ${Status}     Run Keyword And Return Status    Wait Until Element Is Visible    (//button[@aria-label="Expand"])[1]    2
    Run Keyword If    ${Status}    Wait And Click     (//button[@aria-label="Expand"])[1]
    ${Status}     Run Keyword And Return Status    Wait Until Element Is Visible    (//button[@aria-label="Expand"])[1]    2
    Run Keyword If    ${Status}    Wait And Click     (//button[@aria-label="Expand"])[1]
    Wait Until Element Is Visible    (//button[@id="button-readDetails"])[1]    2
    ${RowCount}    Get Element Count    //button[@id="button-readDetails"]
    :FOR   ${i}   IN RANGE    1    ${RowCount}
    \   Wait And Click   (//button[@id="button-readDetails"])[${i}]
    \   Wait Until Element Is Visible    //div/p[text()='Zug-Nr.']    ${Timeout}
    \   ${Flag}    Check Text In Table    ${Betriebsstelle}
    \   Exit For Loop If   "${Flag}"=="True"
    \   Wait And Click     //button[@id="closeDrawer"]
    Run Keyword If   "${Flag}"=="True"    Log    Passed :: "${Betriebsstelle}" is found in the table.   ELSE    Fail    Failed :: "${Betriebsstelle}" is not found in the table.

Check Text In Table
    [Arguments]   ${Betriebsstelle}
    ${Flag}    Set Variable    False
    ${TableRows}    Get Element Count    //tbody[@class="sc-hSdWYo ifsUMm"]/tr
    :FOR    ${i}   IN RANGE    1   ${TableRows}
    \   ${Bst}    Get Text    //tbody[@class="sc-hSdWYo ifsUMm"]/tr[${i}]/td[1]
    \   ${Flag}   Set Variable If   "${Betriebsstelle}"=="${Bst}"    True    ${Flag}
    \   Run Keyword If    "${Flag}"=="True"   Scroll To Element By Xpath    //tbody[@class='sc-hSdWYo ifsUMm']/tr[${i}]/td[1]
    \   Run Keyword If    "${Flag}"=="True"   Capture Page Screenshot
    \   Exit For Loop If   "${Flag}"=="True"
    [Return]   ${Flag}

Get Train-Nr From Details
    Wait And Click     (//button[@aria-label="Expand"])[1]
    ${Status}     Run Keyword And Return Status    Wait Until Element Is Visible    (//button[@aria-label="Expand"])[1]    2
    Run Keyword If    ${Status}    Wait And Click     (//button[@aria-label="Expand"])[1]
    ${Status}     Run Keyword And Return Status    Wait Until Element Is Visible    (//button[@aria-label="Expand"])[1]    2
    Run Keyword If    ${Status}    Wait And Click     (//button[@aria-label="Expand"])[1]
    Wait And Click     (//button[@id="button-readDetails"])[1]
    Wait Until Element Is Visible    (//div[@class="sc-gqjmRU nYta row"])[1]/div[3]    ${Timeout}
    ${Vorgangs-Nr_FromDetails}    Get Text    (//div[@class="sc-gqjmRU nYta row"])[1]/div[3]
    Capture Page Screenshot
    [Return]   ${Vorgangs-Nr_FromDetails}

Filter Train-Nr
    [Arguments]    ${Train-Nr}    ${Vorgangs/Zug}=Vorgangs-Nr
    Wait And Click    //button[@id="openFilterPanel"]
    Run Keyword If    "${Vorgangs/Zug}"=="Vorgangs-Nr"    Wait And Input    //input[@name="vorgnr"]    ${Train-Nr}
    ...   ELSE      Wait And Input    //input[@name="zugnummer"]    ${Train-Nr}
    Wait And Click    //button[@id="applyFilter"]
    Wait Until Element Is Visible    (//button[@aria-label="Expand"])[1]    ${Timeout}
    Capture Page Screenshot

Get First Train-Nr
    Wait Until Element Is Visible    (//table)[1]/tbody/tr[1]/td[1]    ${Timeout}
    ${Train-Nr}   Get Text    (//table)[1]/tbody/tr[1]/td[1]
    Capture Page Screenshot
    [Return]   ${Train-Nr}

Select Date
    [Arguments]   ${FromDate}    ${ToDate}
    Wait And Click    //input[@id="geltungszeitraumVon"]
    ${Count}   Get Element Count    (//div[@class="DayPickerInput"]//*[text()="${FromDate}"])[1]
    Wait And Click    (//div[@class="DayPickerInput"]//*[text()="${FromDate}"])[1]
    Wait And Click    //input[@id="geltungszeitraumBis"]
    ${Count}   Get Element Count    (//div[@class="DayPickerInput"]//*[text()="${ToDate}"])[1]
    Wait And Click    (//div[@class="DayPickerInput"]//*[text()="${ToDate}"])[1]
    Capture Page Screenshot

Get Todays Date
    ${TodaysDate}    Get Current Date
    @{TodaysDate}    Split String    ${TodaysDate}   ${SPACE}
    @{TodaysDate}    Split String    @{TodaysDate}[0]   -
    ${TodaysDate}    Set Variable    @{TodaysDate}[-1]
    [Return]   ${TodaysDate}

Click Logo
    Wait And Click    //img[@id="logo"]
    ${Status}    Run Keyword And Return Status    Wait Until Element is Visible    //button[@id="closeFilterPanel"]    5
    Run Keyword Unless    ${Status}    Wait And Click    //img[@id="logo"]

Check Selected Tab
    Wait Until Element Is Visible    //a[text()='${Tabellarische_Sicht}']   ${Timeout}
    ${IsSelected}    Get Element Attribute   //a[text()='${Tabellarische_Sicht}']   aria-selected
    Run Keyword If   '${IsSelected}'=='false'    Fail    ${Tabellarische_Sicht} should be active but it is not active.   ELSE    Log    ${Tabellarische_Sicht} is active as expected.

Login
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Wait And Input    //input[@id="username"]       ${Username}
    Wait And Input    //input[@id="password"]       ${Password}
    Wait And Click    //button[@id="login"]


Logout
    Wait And Click      //a[text()='Abmelden']
    Wait Until Element Is Visible    //input[@id="username"]
    Capture Page Screenshot
    Close Browser

Edit User Settings
    Wait And Click   //a[@id="nav-dropdown-admin"]
    Wait And Click   //a[text()='Benutzereinstellungen']
    Wait Until Element Is Visible    //select[@class="form-control"]    ${Timeout}
    Sleep   2
    Select From List By Label    //select[@class="form-control"]        ${Standard-Filterfavorit}
    Wait And Click    //input[@value="${Tabellarische_Sicht}"]
    Wait And Click    //label[text()='${Darstellung_Ergebnissicht}']
    Capture Page Screenshot
    Wait And Click    //button[@id="button--saveUserSettings"]
    Wait Until Element Is Visible    //div[text()='Die Änderungen wurden erfolgreich gespeichert']    ${Timeout}

Wait And Input
    [Arguments]   ${Locator}    ${Text}
    Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Input Text    ${Locator}   ${Text}

Wait And Click
    [Arguments]   ${Locator}    ${Timeout}=${Timeout}
    Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Click Element    ${Locator}

Scroll To Element By Xpath
    [Arguments]    ${xpath}
    ${xpath1} =    Replace String    ${xpath}    xpath=    ${EMPTY}
    Execute Javascript    document.evaluate("${xpath1}",document,null,    XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue.scrollIntoView(true);
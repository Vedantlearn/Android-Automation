*** Settings ***
Library    AppiumLibrary
Library    Process
Library    OperatingSystem
Library    XML

*** Variables ***
&{chromeOptions}    w3c=${False}

${UserName}     jyenne@zensar.com
${Password}     123456789

# First Page
${permit_button1}         id=mx.com.liverpool.shoppingapp:id/btn_allow_permission
${Salar_button}           //android.widget.TextView[@resource-id="mx.com.liverpool.shoppingapp:id/skip_action"]

# Home Page
${Dont_Allow_notification}      //android.widget.Button[@resource-id="com.android.permissioncontroller:id/permission_deny_button"]
${Mi_cuente_footer_Text}       //android.widget.TextView[contains(@text,'Mi cuenta')]
${Footer_Home}      xpath=(//android.widget.ImageView[@resource-id="mx.com.liverpool.shoppingapp:id/navigation_bar_item_icon_view"])[1]
${Search_bar}       id=mx.com.liverpool.shoppingapp:id/edt_header_searchbar_old

# Search Page
${Search_Bar_Clicked}   id=mx.com.liverpool.shoppingapp:id/edt_header_searchbar

#Product List Page
${Product_1_Name}     xpath=(//android.widget.TextView[@resource-id='mx.com.liverpool.shoppingapp:id/title_item_plp'])[1]
${Product_1_Image}      xpath=(//android.widget.ImageView[@resource-id='mx.com.liverpool.shoppingapp:id/image_plp_item'])[1]

#Product Detail Page
${Product_Name}     id=mx.com.liverpool.shoppingapp:id/tv_displayName
${Product_Id}       id=mx.com.liverpool.shoppingapp:id/tv_productId
${Product_Image}     id=mx.com.liverpool.shoppingapp:id/image_banner_carousel
${Product_Price}        id=mx.com.liverpool.shoppingapp:id/tv_productMinPromoPrice
${Agregar_a_mi_bolsa}     id=mx.com.liverpool.shoppingapp:id/btnAddMyBag
${Whislist}     id=mx.com.liverpool.shoppingapp:id/stickkyBarAdd_to_wishlist_imageview
${Header_bag}       id=mx.com.liverpool.shoppingapp:id/btn_header_bag

# Mi Cuenta
${inicear}      id=mx.com.liverpool.shoppingapp:id/txt_Login
${Total_Price}     id=mx.com.liverpool.shoppingapp:id/total_price
${Compare}      id=mx.com.liverpool.shoppingapp:id/btnPayBottom
${Item}     id=mx.com.liverpool.shoppingapp:id/ll_item_product
${plus_Quantity}        id=mx.com.liverpool.shoppingapp:id/btn_quantity_plus
${Quantity_Text}         xpath=(//android.widget.EditText)[1]

# WebView Login
${Button_Without_Account}   //android.widget.Button[contains(@text,'Use without an account')]
${User_Input}               xpath=//input[@id='username']
${Password_Input}           xpath=//input[@type='password']
${Inicear_submit}           //android.widget.Button[@text='Iniciar sesión']
#Mi Bolsa
${Header_Title}     id=mx.com.liverpool.shoppingapp:id/txt_header_title

*** Test Cases ***
Login
    # Launch the app
    Open Application    http://localhost:4723
    ...    platformName=Android
    ...    deviceName=emulator-5554
    ...    appPackage=mx.com.liverpool.shoppingapp
    ...    appActivity=mx.com.liverpool.shoppingapp.splash.view.SplashActivity
    ...    automationName=UiAutomator2
    ...    chromedriver_autodownload=true

    # Handle initial permissions
    Wait Until Element Is Visible    ${permit_button1}    30 seconds
    Click Element    ${permit_button1}

    Wait Until Element Is Visible    ${Salar_button}    30 seconds
    Click Element    ${Salar_button}

    Wait Until Element Is Visible    ${Dont_Allow_notification}    30 seconds
    Click Element    ${Dont_Allow_notification}

    # Navigate to login
    Wait Until Element Is Visible    ${Mi_cuente_footer_Text}    30 seconds
    Click Element    ${Mi_cuente_footer_Text}

    Wait Until Element Is Visible    ${inicear}    30 seconds
    Click Element    ${inicear}

    Sleep    12 seconds

    # Switch to WebView context
    ${contexts}=    Get Contexts
    Log To Console    CONTEXTS: ${contexts}
    Switch To Context    WEBVIEW_chrome



    FOR    ${context}    IN    @{contexts}
        Run Keyword If    '${context}' != 'NATIVE_APP' and '${context}'.startswith('WEBVIEW')
        ...    Switch To Context    ${context}
        Run Keyword If    '${context}' != 'NATIVE_APP' and '${context}'.startswith('WEBVIEW')
        ...    Log    Switched to context: ${context}
        Exit For Loop If    '${context}' != 'NATIVE_APP' and '${context}'.startswith('WEBVIEW')
    END
    Capture Page Screenshot

    # Interact with WebView login
    Wait Until Element Is Visible    ${User_Input}    30 seconds
    Input Text    ${User_Input}    ${UserName}

    Wait Until Element Is Visible    ${Password_Input}    30 seconds
    Input Text    ${Password_Input}    ${Password}

    Click Element    xpath=//button[@type='submit' and contains(., "Iniciar sesión")]

    # Switch back to native context
    Switch To Context    NATIVE_APP

    # Verify login
#    Wait Until Element Is Visible    ${Mi_cuente_fotter_Text}    30 seconds
    Sleep    7 seconds

Search
    #perform search
    Wait Until Element Is Visible    ${Footer_Home}     30 seconds
    Click Element    ${Footer_Home}
    Click Element    ${Search_bar}
    Press Keycode    66
    Wait Until Element Is Visible    ${Search_Bar_Clicked}
    Input Text    ${Search_Bar_Clicked}     Vasos
    Press Keycode    66
    Capture Page Screenshot

    Sleep    7 seconds
    Wait Until Element Is Visible   ${Product_1_Name}
    Wait Until Element Is Visible   ${Product_1_Image}

Product detail page
    Click Element       ${Product_1_Name}
#    Sleep    7 seconds
 #   Capture Page Screenshot
#    Swipe    500    2000    500    100    800
    Sleep    7 seconds
Swipe to mid add to cart
    Wait Until Element Is Visible   ${Product_Image}
    Wait Until Element Is Visible   ${Product_Name}
    Wait Until Element Is Visible   ${Product_Price}
    Swipe By Percent    50    80    50    20
    Swipe By Percent    50    80    50    20
    Capture Page Screenshot
    Wait Until Element Is Visible    ${Agregar_a_mi_bolsa}
    Click Element    ${Agregar_a_mi_bolsa}

Cart page check
    Click Element    ${Header_bag}
    Wait Until Element Is Visible    ${Header_Title}
    Wait Until Element Is Visible    ${plus_Quantity}

    Wait Until Element Is Visible    ${Quantity_Text}
    ${Quantity_Before}=    AppiumLibrary.Get Element Attribute    ${Quantity_Text}     text
    Should Not Be Empty    ${Quantity_Before}    Quantity field is empty!
    ${Quantity_Before}=    Convert To Integer    ${Quantity_Before}

    Click Element    ${plus_Quantity}
    Sleep    5 seconds
    Wait Until Element Is Visible    ${Quantity_Text}
    ${Quantity_After}=    AppiumLibrary.Get Element Attribute    ${Quantity_Text}     text
    Should Not Be Empty    ${Quantity_After}    Quantity field is empty!
    ${Quantity_After}=    Convert To Integer    ${Quantity_After}

    Should Be True    ${Quantity_After} > ${Quantity_Before}

    AppiumLibrary.Element Text Should Be    ${Header_Title}    Mi bolsa
    Wait Until Element Is Visible    ${Compare}
    Wait Until Element Is Visible    ${Item}

    Close Application

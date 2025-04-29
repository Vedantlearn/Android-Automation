*** Settings ***
Library    AppiumLibrary
Library    Process
Library    OperatingSystem

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
${Sort_By}      id=mx.com.liverpool.shoppingapp:id/text_sort_plp
${Filtter}      id=mx.com.liverpool.shoppingapp:id/text_filter_plp
${Express_Radio_Button}     id=mx.com.liverpool.shoppingapp:id/ln_view_express_plp
${Relavance_SortBy}    xpath=(//android.widget.TextView[@resource-id='mx.com.liverpool.shoppingapp:id/title' and @text='Relevancia'])[1]
${Lo Más Nuevo}     xpath=//android.widget.TextView[@resource-id='mx.com.liverpool.shoppingapp:id/title' and @text='Lo Más Nuevo']

#filtter
${Descuentos}       xpath=(//android.widget.TextView[@resource-id='mx.com.liverpool.shoppingapp:id/text_name_filter_type' and @text='Descuentos'])[1]
${Marcas}     xpath=//android.widget.TextView[@resource-id='mx.com.liverpool.shoppingapp:id/text_name_filter_type' and @text='Marcas']
${Descuentos_Option1}       xpath=(//android.widget.TextView[@resource-id='mx.com.liverpool.shoppingapp:id/text_label_option_filter_item'])[1]
${Option1_Sealected_Text}       xpath=//android.widget.TextView[@resource-id='mx.com.liverpool.shoppingapp:id/text_chips_filter_quantity' and @text='Filtros seleccionados (1)']
${Fillter_Submit}       xpath=//android.widget.Button[@resource-id='mx.com.liverpool.shoppingapp:id/button_apply_filter_drawer']


# Mi Cuenta
${inicear}      id=mx.com.liverpool.shoppingapp:id/txt_Login

# WebView Login
${Button_Without_Account}   //android.widget.Button[contains(@text,'Use without an account')]
${User_Input}               xpath=//input[@id='username']
${Password_Input}           xpath=//input[@type='password']
${Inicear_submit}           //android.widget.Button[@text='Iniciar sesión']

*** Test Cases ***
App launch
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



    Capture Page Screenshot
login page
    # Interact with WebView login
    Wait Until Element Is Visible    ${User_Input}    30 seconds
    Input Text    ${User_Input}    ${UserName}

    Wait Until Element Is Visible    ${Password_Input}    30 seconds
    Input Text    ${Password_Input}    ${Password}

    Click Element    xpath=//button[@type='submit' and contains(., "Iniciar sesión")]
home page
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
    Input Text    ${Search_Bar_Clicked}     Vasos
    Press Keycode    66
    Capture Page Screenshot

    Sleep    7 seconds
    Wait Until Element Is Visible   ${Product_1_Name}
    Wait Until Element Is Visible   ${Product_1_Image}
Sort By feature
    Wait Until Element Is Visible    ${Sort_By}
    Click Element    ${Sort_By}
    Wait Until Element Is Visible    ${Relavance_SortBy}
    Wait Until Element Is Visible    ${Lo Más Nuevo}

    Click Element    ${Lo Más Nuevo}
filtter options
    Wait Until Element Is Visible    ${Filtter}
    Click Element    ${Filtter}
    Wait Until Element Is Visible    ${Descuentos}
    Wait Until Element Is Visible    ${Marcas}
    Click Element    ${Descuentos}
    Wait Until Element Is Visible    ${Descuentos_Option1}
    Click Element    ${Descuentos_Option1}
    Wait Until Element Is Visible    ${Option1_Sealected_Text}
    Wait Until Element Is Visible    ${Fillter_Submit}
    Click Element    ${Fillter_Submit}
    Page Should Not Contain Element    ${Fillter_Submit}

*** Settings ***
Library    OperatingSystem
Library    Process

*** Variables ***
${APPJDK}    adopt@1.8.0-292
${JENKINSJDK}    openjdk@21.0.0

*** Test Cases ***
Set Up Appium Test
    Set Java Version For Appium
    Run Appium Tests

Set Up Jenkins Build
    Set Java Version For Jenkins
    Run Jenkins Build

*** Keywords ***
Set Java Version For Appium
    Set Environment Variable    JAVA_HOME    ${APPJDK}
    Run Process   jabba use ${APPJDK}

Set Java Version For Jenkins
    Set Environment Variable    JAVA_HOME    ${JENKINSJDK}
    Run Process    jabba use ${JENKINSJDK}

Run Appium Tests
    # Place the code to run your Appium tests here
    Log    Running Appium tests with JDK 8

Run Jenkins Build
    # Place your Jenkins build steps here
    Log    Running Jenkins build with JDK 21

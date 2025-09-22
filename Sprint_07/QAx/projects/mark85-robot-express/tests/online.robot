*** Settings ***
Documentation       Online

#Para ter acesso aos recursos da lib Browser
Resource    ../resources/base.resource

*** Test Cases ***
Webapp deve estar online
    Start Session
    Get Title       equal       Mark85 by QAx
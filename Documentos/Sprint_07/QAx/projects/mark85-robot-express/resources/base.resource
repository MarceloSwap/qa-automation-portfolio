*** Settings ***

Library        libs/database.py
Library        Browser
Library        JSONLibrary
Library        String

Resource       env.resource

Resource       pages/components/Header.resource
Resource       pages/components/Alert.resource
Resource       pages/components/Notice.resource

Resource       pages/SignupPage.resource
Resource       pages/LoginPage.resource
Resource       pages/TaskCreatePage.resource
Resource       pages/TasksPage.resource

*** Keywords ***
Start Session
    
    New Browser     browser=${BROWSER}      headless=False
    New Page        ${BASE_URL}


# HELPERS

Get fixture
    [Arguments]        ${file_name}        ${scenario}
    # Carregando os dados em json e utf-8 pra corrigir erros de caracteres
    ${data}        Load Json From File    ${EXECDIR}/resources/fixtures/${file_name}.json
    ...            encoding=utf-8
    
    RETURN        ${data}[${scenario}]
*** Settings ***

Library        libs/database.py
Library        Browser
Library        JSONLibrary
Library        String
Library        Collections

Resource       env.resource

Resource       pages/components/Header.resource
Resource       pages/components/Alert.resource
Resource       pages/components/Notice.resource
Resource       pages/components/Navigation.resource

Resource       pages/RegisterPage.resource
Resource       pages/LoginPage.resource
Resource       pages/ProfilePage.resource
Resource       pages/LogoutPage.resource
Resource       pages/MoviesPage.resource
Resource       pages/MovieDetailsPage.resource
Resource       pages/SessionsPage.resource
Resource       pages/SeatsPage.resource
Resource       pages/CheckoutPage.resource
Resource       pages/ReservationsPage.resource
Resource       pages/HomePage.resource


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
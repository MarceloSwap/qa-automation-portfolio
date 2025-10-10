*** Settings ***
Documentation    Configurações base para testes da API Cinema
Library          RequestsLibrary
Library          Collections
Library          String
Library          DateTime
Library          JSONLibrary
Library          FakerLibrary    locale=pt_BR

*** Variables ***
${BASE_URL}         http://localhost:3000/api/v1
${TIMEOUT}          30
${VALID_EMAIL}      test@cinema.com
${VALID_PASSWORD}   123456
${ADMIN_EMAIL}      admin@cinema.com
${ADMIN_PASSWORD}   admin123

# Headers
&{HEADERS}          Content-Type=application/json
&{AUTH_HEADERS}     Content-Type=application/json    Authorization=Bearer ${EMPTY}

*** Keywords ***
Setup Test Session
    [Documentation]    Configura sessão HTTP para os testes
    Create Session    cinema_api    ${BASE_URL}    timeout=${TIMEOUT}
    Set Suite Variable    ${SESSION}    cinema_api

Teardown Test Session
    [Documentation]    Finaliza sessão HTTP
    Delete All Sessions

Generate Random User Data
    [Documentation]    Gera dados aleatórios para usuário
    ${name}=    FakerLibrary.Name
    ${email}=    FakerLibrary.Email
    ${password}=    Set Variable    123456
    
    &{user_data}=    Create Dictionary
    ...    name=${name}
    ...    email=${email}
    ...    password=${password}
    
    RETURN    &{user_data}

Generate Random Movie Data
    [Documentation]    Gera dados aleatórios para filme
    ${title}=    FakerLibrary.Sentence    nb_words=3
    ${synopsis}=    FakerLibrary.Text    max_nb_chars=200
    ${director}=    FakerLibrary.Name
    ${duration}=    FakerLibrary.Random Int    min=90    max=180
    ${classification}=    FakerLibrary.Random Element    elements=@{CLASSIFICATIONS}
    ${release_date}=    FakerLibrary.Date Between    start_date=-2y    end_date=+1y
    ${release_date_str}=    Convert Date    ${release_date}    result_format=%Y-%m-%d
    
    @{genres}=    Create List    Ação    Drama
    
    &{movie_data}=    Create Dictionary
    ...    title=${title}
    ...    synopsis=${synopsis}
    ...    director=${director}
    ...    genres=${genres}
    ...    duration=${duration}
    ...    classification=${classification}
    ...    releaseDate=${release_date_str}
    ...    poster=https://example.com/poster.jpg
    
    RETURN    &{movie_data}

Extract Token From Response
    [Documentation]    Extrai token JWT da resposta de login
    [Arguments]    ${response}
    ${token}=    Get Value From Json    ${response.json()}    $.data.token
    ${token}=    Get From List    ${token}    0
    RETURN    ${token}

Set Authorization Header
    [Documentation]    Define header de autorização com token
    [Arguments]    ${token}
    Set To Dictionary    ${AUTH_HEADERS}    Authorization=Bearer ${token}

Validate Response Structure
    [Documentation]    Valida estrutura básica da resposta da API
    [Arguments]    ${response}    ${expected_status}=200
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    success
    RETURN    ${json_response}

*** Variables ***
@{CLASSIFICATIONS}    Livre    10    12    14    16    18
*** Settings ***
Documentation        Elementos e ações da página de detalhes do filme

Library        Browser
Resource       ../env.resource

*** Variables ***
# Seletores da página de detalhes do filme
${MOVIE_DETAIL_CONTAINER}    css=.movie-detail-container
${MOVIE_POSTER}              css=.movie-poster img
${MOVIE_TITLE}               css=.movie-info h1
${MOVIE_SYNOPSIS}            css=.movie-synopsis p
${SESSIONS_CONTAINER}        css=.sessions-container
${SESSION_CARD}              css=.session-card
${SESSION_BUTTON}            css=.session-button

*** Keywords ***
Wait For Movie Details Page
    [Documentation]    Aguarda o carregamento da página de detalhes do filme
    Wait For Elements State    ${MOVIE_DETAIL_CONTAINER}    visible    10
    Wait For Elements State    ${MOVIE_TITLE}    visible    10
    Wait For Load State    networkidle

Should Display Movie Information
    [Documentation]    Verifica se as informações do filme estão sendo exibidas
    Wait For Elements State    ${MOVIE_POSTER}    visible    5
    Wait For Elements State    ${MOVIE_TITLE}    visible    5
    Wait For Elements State    ${MOVIE_SYNOPSIS}    visible    5

Should Display Sessions
    [Documentation]    Verifica se há sessões disponíveis
    Wait For Elements State    ${SESSIONS_CONTAINER}    visible    10
    ${sessions}=    Get Elements    ${SESSION_CARD}
    ${count}=    Get Length    ${sessions}
    Should Be True    ${count} > 0    Nenhuma sessão encontrada

Click First Session Select Seats Button
    [Documentation]    Clica no botão Selecionar Assentos da primeira sessão
    Wait For Elements State    ${SESSION_CARD}    visible    10
    Click    css=.session-card:first-child a.session-button
    Wait For Load State    networkidle

Get Movie Title
    [Documentation]    Obtém o título do filme
    ${title}=    Get Text    ${MOVIE_TITLE}
    RETURN    ${title}

Get Sessions Count
    [Documentation]    Retorna a quantidade de sessões disponíveis
    ${sessions}=    Get Elements    ${SESSION_CARD}
    ${count}=    Get Length    ${sessions}
    RETURN    ${count}
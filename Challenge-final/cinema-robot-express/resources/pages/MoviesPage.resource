*** Settings ***
Documentation        Elementos e ações da página de filmes

Resource       ../base.resource

*** Variables ***
# Seletores da página de filmes
${MOVIES_CONTAINER}        css=.movies-container
${MOVIES_GRID}             css=.movies-grid
${MOVIE_CARD}              css=.movie-card
${MOVIE_POSTER}            css=.movie-poster img
${MOVIE_TITLE}             css=.movie-title
${MOVIE_CLASSIFICATION}    css=.movie-classification
${MOVIE_GENRES}            css=.movie-genres
${MOVIE_DURATION}          css=.movie-duration
${MOVIE_RELEASE_DATE}      css=.movie-release-date
${MOVIES_LOADING}          css=.loading-movies
${NO_MOVIES_MESSAGE}       css=.no-movies-message

*** Keywords ***
Aguardar Carregamento da Página de Filmes
    [Documentation]    Aguarda o carregamento completo da página de filmes
    Wait For Elements State    ${MOVIES_CONTAINER}    visible    10
    Wait For Load State        networkidle

Verificar Layout Grid dos Filmes
    [Documentation]    Verifica se os filmes estão exibidos em layout grid
    Wait For Elements State    ${MOVIES_GRID}    visible    5
    ${grid_display}=    Get Style    ${MOVIES_GRID}    display
    Should Contain    ${grid_display}    grid

Verificar Cards de Filmes Visíveis
    [Documentation]    Verifica se há cards de filmes visíveis na página
    ${movie_cards}=    Get Elements    ${MOVIE_CARD}
    ${cards_count}=    Get Length    ${movie_cards}
    Should Be True    ${cards_count} > 0    Nenhum card de filme encontrado

Verificar Elementos do Card do Filme
    [Documentation]    Verifica se um card de filme contém todos os elementos necessários
    [Arguments]    ${card_index}=0
    
    ${movie_cards}=    Get Elements    ${MOVIE_CARD}
    ${card}=    Set Variable    ${movie_cards}[${card_index}]
    
    # Verifica pôster
    Wait For Elements State    ${card} >> ${MOVIE_POSTER}    visible    5
    
    # Verifica título
    Wait For Elements State    ${card} >> ${MOVIE_TITLE}    visible    5
    ${title_text}=    Get Text    ${card} >> ${MOVIE_TITLE}
    Should Not Be Empty    ${title_text}
    
    # Verifica elementos opcionais (podem não estar presentes)
    ${classification_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${card} >> ${MOVIE_CLASSIFICATION}    visible    2
    
    ${genres_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${card} >> ${MOVIE_GENRES}    visible    2
    
    ${duration_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${card} >> ${MOVIE_DURATION}    visible    2
    
    ${release_date_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${card} >> ${MOVIE_RELEASE_DATE}    visible    2
    
    # Pelo menos um dos elementos opcionais deve estar presente
    ${has_optional_info}=    Evaluate    ${classification_exists} or ${genres_exists} or ${duration_exists} or ${release_date_exists}
    Should Be True    ${has_optional_info}    Card deve ter pelo menos uma informação adicional

Verificar Qualidade do Pôster
    [Documentation]    Verifica se o pôster tem boa qualidade (tamanho adequado)
    [Arguments]    ${card_index}=0
    
    ${movie_cards}=    Get Elements    ${MOVIE_CARD}
    ${card}=    Set Variable    ${movie_cards}[${card_index}]
    ${poster}=    Get Element    ${card} >> ${MOVIE_POSTER}
    
    # Verifica se a imagem carregou
    ${poster_src}=    Get Attribute    ${poster}    src
    Should Not Be Empty    ${poster_src}
    
    # Verifica dimensões mínimas (valores mais flexíveis)
    ${width}=    Get Property    ${poster}    offsetWidth
    ${height}=    Get Property    ${poster}    offsetHeight
    Should Be True    ${width} >= 100    Pôster muito pequeno (largura: ${width}px)
    Should Be True    ${height} >= 150    Pôster muito pequeno (altura: ${height}px)
    
    # Verifica se a imagem não está quebrada
    ${natural_width}=    Get Property    ${poster}    naturalWidth
    Should Be True    ${natural_width} > 0    Imagem do pôster não carregou corretamente

Clicar no Filme
    [Documentation]    Clica em um card de filme para acessar detalhes
    [Arguments]    ${card_index}=0
    
    ${movie_cards}=    Get Elements    ${MOVIE_CARD}
    ${card}=    Set Variable    ${movie_cards}[${card_index}]
    Click    ${card}

Obter Título do Filme
    [Documentation]    Obtém o título de um filme específico
    [Arguments]    ${card_index}=0
    
    ${movie_cards}=    Get Elements    ${MOVIE_CARD}
    ${card}=    Set Variable    ${movie_cards}[${card_index}]
    ${title}=    Get Text    ${card} >> ${MOVIE_TITLE}
    RETURN    ${title}

Verificar Responsividade
    [Documentation]    Verifica se o layout se adapta a diferentes tamanhos de tela
    
    # Testa em desktop
    Set Viewport Size    1920    1080
    Sleep    1s
    Verificar Layout Grid dos Filmes
    
    # Testa em tablet
    Set Viewport Size    768    1024
    Sleep    1s
    Verificar Layout Grid dos Filmes
    
    # Testa em mobile
    Set Viewport Size    375    667
    Sleep    1s
    Verificar Layout Grid dos Filmes

Navegar para Página de Filmes
    [Documentation]    Navega para a página de filmes
    Go To    ${BASE_URL}/movies
    Aguardar Carregamento da Página de Filmes
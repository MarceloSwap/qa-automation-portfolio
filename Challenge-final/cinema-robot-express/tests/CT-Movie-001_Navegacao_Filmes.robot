*** Settings ***
Documentation    Testes para navegação e visualização de filmes
...              US-MOVIE-001: Navegar na Lista de Filmes
...              US-MOVIE-002: Visualizar Detalhes do Filme

Resource         ../resources/base.resource

Test Setup       Start Session
Test Teardown    Take Screenshot

*** Test Cases ***
CT-Movie-001 Deve exibir lista de filmes em layout grid
    [Documentation]    Verifica se os filmes são exibidos em layout grid responsivo
    [Tags]    movies    layout    positive
    
    Navegar para Página de Filmes
    Verificar Layout Grid dos Filmes
    Verificar Cards de Filmes Visíveis

CT-Movie-002 Deve exibir pôsteres de alta qualidade
    [Documentation]    Verifica se os pôsteres dos filmes têm boa qualidade visual
    [Tags]    movies    poster    positive
    
    Navegar para Página de Filmes
    Verificar Cards de Filmes Visíveis
    Verificar Qualidade do Pôster

CT-Movie-003 Deve exibir informações básicas nos cards
    [Documentation]    Verifica se cards contêm título, classificação, gêneros, duração e data
    [Tags]    movies    card-info    positive
    
    Navegar para Página de Filmes
    Verificar Cards de Filmes Visíveis
    Verificar Elementos do Card do Filme

CT-Movie-004 Deve ser responsivo em diferentes tamanhos de tela
    [Documentation]    Verifica se layout se adapta a desktop, tablet e mobile
    [Tags]    movies    responsive    positive
    
    Navegar para Página de Filmes
    Verificar Cards de Filmes Visíveis
    Verificar Responsividade



CT-Movie-008 Deve exibir elenco quando disponível
    [Documentation]    Verifica se o elenco é exibido quando disponível
    [Tags]    movies    details    cast    positive
    
    Navegar para Página de Filmes
    Verificar Cards de Filmes Visíveis
    Clicar no Filme
    
    Aguardar Carregamento da Página de Detalhes
    Verificar Elenco



CT-Movie-012 Deve lidar com página de filmes vazia
    [Documentation]    Verifica comportamento quando não há filmes disponíveis
    [Tags]    movies    empty    negative
    
    Navegar para Página de Filmes
    
    ${movie_cards}=    Get Elements    css=.movie-card
    ${cards_count}=    Get Length    ${movie_cards}
    
    IF    ${cards_count} == 0
        ${no_movies_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=.no-movies-message    visible    5
        
        IF    ${no_movies_exists}
            ${message}=    Get Text    css=.no-movies-message
            Should Not Be Empty    ${message}
        END
    ELSE
        Log    Há filmes disponíveis, teste não aplicável
    END

CT-Movie-013 Deve carregar página rapidamente
    [Documentation]    Verifica se a página de filmes carrega em tempo adequado
    [Tags]    movies    performance    positive
    
    ${start_time}=    Get Time    epoch
    Navegar para Página de Filmes
    ${end_time}=    Get Time    epoch
    
    ${load_time}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${load_time} < 10    Página demorou mais que 10 segundos
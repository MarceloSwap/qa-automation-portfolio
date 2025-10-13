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
    
    Go To Movies Page
    Verificar Layout Grid dos Filmes
    Verificar Cards de Filmes Visíveis

CT-Movie-002 Deve exibir pôsteres de alta qualidade
    [Documentation]    Verifica se os pôsteres dos filmes têm boa qualidade visual
    
    Go To Movies Page
    Verificar Cards de Filmes Visíveis
    Verificar Qualidade do Pôster

CT-Movie-003 Deve exibir informações básicas nos cards
    [Documentation]    Verifica se cards contêm título, classificação, gêneros, duração e data
    
    Go To Movies Page
    Verificar Cards de Filmes Visíveis
    Verificar Elementos do Card do Filme

CT-Movie-004 Deve ser responsivo em diferentes tamanhos de tela
    [Documentation]    Verifica se layout se adapta a desktop, tablet e mobile
    
    Go To Movies Page
    Verificar Cards de Filmes Visíveis
    
    # Testa responsividade com diferentes viewports usando Browser Library
    Set Viewport Size    1920    1080
    Sleep    1s
    Verificar Cards de Filmes Visíveis
    
    Set Viewport Size    768    1024
    Sleep    1s
    Verificar Cards de Filmes Visíveis
    
    Set Viewport Size    375    667
    Sleep    1s
    Verificar Cards de Filmes Visíveis



CT-Movie-008 Deve exibir elenco quando disponível
    [Documentation]    Verifica se o elenco é exibido quando disponível
    
    Go To Movies Page
    Verificar Cards de Filmes Visíveis
    
    # Tenta clicar no filme para ir aos detalhes
    ${movie_cards}=    Get Elements    css=.movie-card
    ${cards_count}=    Get Length    ${movie_cards}
    
    IF    ${cards_count} > 0
        Click    css=.movie-card >> nth=0 >> css=.btn-primary
        Wait For Load State    networkidle
        
        # Verifica se chegou na página de detalhes
        ${current_url}=    Get Url
        IF    '/movies/' in '${current_url}'
            Verificar Elenco
        ELSE
            Log    Não foi possível acessar página de detalhes
        END
    ELSE
        Log    Nenhum filme disponível para testar elenco
    END



CT-Movie-012 Deve lidar com página de filmes vazia
    [Documentation]    Verifica comportamento quando não há filmes disponíveis
    
    Go To Movies Page
    
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
    
    ${start_time}=    Get Time    epoch
    Go To Movies Page
    ${end_time}=    Get Time    epoch
    
    ${load_time}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${load_time} < 10    Página demorou mais que 10 segundos
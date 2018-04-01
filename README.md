# Requisitos
- Xcode 8
- Swift 3
- Cocoapods 1.3.1

# Antes de rodar o projeto
Antes de rodar o projeto, por favor,rode 'pod install' dentro da pasta onde se encontra o Podfile

# Arquitetura
**View:** 
A camada de *view* é responsável por mostrar a tela ao usuário. Uma *view* sabe como e onde exibir seu conteúdo na tela. Ela será responsável pela interface do usuário, como por exemplo, reconhecedores de gestos do usuário e componentes personalizados.

**Controller:**
Uma *controller* atua como um intermediário entre um ou mais objetos de exibição em um aplicativo e seus gerenciadores. Objetos de uma *controller* comandam a visualização de objetos, notificando a *view* sobre alterações no modelo e vice-versa. A camada de *controller* também será responsável por implementar o fluxo de navegação tratar eventos do app. Ela implementará protocolos padrões do iOS, como *UICollectionViewDataSource* e *UICollectionViewDelegate*.

**Manager:** 

Essa camada é responsável pelo controle do fluxo de operações. Ele se comunica diretamente com a camada *Controller* e a camada *Business* e pode conter uma instância do NSOperationQueue acessada de uma classe do *Base Manager* para controlar operações assíncronas e cancelar, pausar ou fazer dependências entre operações de forma mais simples.

**Business:** 
Essa camada contém as regras de negócio que são aplicadas pelo app. Nesta camada da arquitetura, são feitas as chamadas aos provedores de dados. Depois de recolhidos os dados, a *Business* trata as regras de negócio de acordo e também faz o tratamento de eventuais erros.

**Provider:**
A camada de *Provider* é responsável pela abstração de bibliotecas e provedores de dados que o aplicativo possa ter. Neste caso o Alamofire representa boa parte da camada de *Provider*, pois esta biblioteca realizar as requisições ao *backend* para buscar os dados, fazendo o papel do "*Base Provider*".  

# Dependencias
- lottie-ios: Biblioteca do AirBnb para incluir a animação inicial e de lista vazia.
- Alamofire: Biblioteca para realizar requisições a partir de URL
- AlamofireImage: Biblioteca de image loader e cacher para baixar as imagens da Internet
- Reachability: Verificador de conexão com a Internet

# WhatsappWeb

Projeto baseado no curso "Flutter 2.0: Crie aplicações responsivas para a Web", disponível na Udemy.

## Iniciando

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)
- [FlutterFire](https://firebase.flutter.dev/docs/overview/)
- [Firebase Console](https://console.firebase.google.com/)
- [Online documentation](https://flutter.dev/docs)

## Hospedagem

Publicar sua aplicação com Firebase Hosting

1. Instalar Node JS / Firebase Tools
    - node --version (node -v)
    - npm install -g firebase-tools
2. Logar no firebase
    - firebase login
3. Listar projetos (opcional)
    - firebase projects:list
4. Executar uma versão que será publicada (opcional)
    - flutter run -d chrome --release
5. Construir projeto
    - flutter build web
6. Inicializar os serviços do Firebase
    - firebase init
    - Hosting: Configure files for Firebase Hosting an (optionally) set up Github Action deploys
    - Use an existing project
    - What do you want to use as your public directory? (public)
        - build/web
    - Configure as a single-page app (rewrite all urls to /index.html)?
        - y
    - Set up automatic builds and deploys wit Github?
        - y
    - File build/web/idex.html already exists. Overwrite?
        - n
    - Set up the workflow to ru a build script before every deploy?
        - y
    - What script should be run before every deploy?
        - npm run build
7. Fazer a publicação para o Firebase
    - firebase deploy
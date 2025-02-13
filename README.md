### 🔍 My Custom Lints  

🚀 Um conjunto de regras personalizadas para melhorar a qualidade do código em projetos Flutter/Dart.  

### 📌 Instalação  

Adicione o package ao seu `pubspec.yaml`:  

```yaml
dev_dependencies:
  my_custom_lints:
    git:
      url: https://github.com/WemersonDamasceno/my_custom_lints.git
      ref: main
```

Execute:  

```sh
flutter pub get
```

### ⚡ Como Usar  

Crie (ou edite) o arquivo `analysis_options.yaml` no seu projeto e adicione:  

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    - use_my_design_system:
      AppButtonWidget:
        - instead_of: ElevatedButton
          from_package: flutter
      # Adicione todos os Widgets que serão utilizados em seu projeto que já estão no Design System.

   
linter:
  rules:
    - always_declare_return_types
    # Adicione todas as regras que voce queira...
```

Agora, ao rodar:  

```sh
dart run custom_lint
```

Ou no Flutter:  

```sh
flutter analyze
```

Você verá os lints personalizados aplicados ao projeto.  


### 🛠 Contribuindo  

Fique à vontade para abrir **issues** e enviar **pull requests**. Qualquer melhoria ou nova regra será bem-vinda!  

1. Faça um fork do repositório  
2. Crie uma branch (`git checkout -b feature/minha-feature`)  
3. Commit suas alterações (`git commit -m 'Adiciona nova regra'`)  
4. Faça push para a branch (`git push origin feature/minha-feature`)  
5. Abra um Pull Request 🚀  

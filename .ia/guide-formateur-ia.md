# Guide formateur — Utiliser l'IA en cours

## Philosophie

L'IA est un **outil de compréhension**, pas un copieur de code.
En formation 3IAC1, l'encourager pour :
- expliquer un concept qui n'est pas clair
- déboguer une erreur bloquante
- générer une variante d'exercice pour aller plus loin

La décourager pour :
- faire le TP à la place de l'étudiant
- générer du code sans le lire ni le comprendre

---

## Pendant les TPs — Comment guider les étudiants

### Si un étudiant est bloqué (règle des 10 minutes)
Après 10 minutes sans avancement :
1. L'étudiant décrit son problème à l'IA en français
2. L'IA propose une piste — pas forcément la solution complète
3. L'étudiant applique et explique ce qu'il comprend

### Prompt de déblocage recommandé
```
Je travaille sur le TP [numéro] de la formation 3IAC1.
Contexte : [décrire ce qu'on essaie de faire]
Erreur obtenue : [coller l'erreur]
Ce que j'ai essayé : [décrire]
Donne-moi une piste, pas la solution complète.
```

### Après chaque TP
Encourager les étudiants à demander à l'IA :
```
Explique-moi ce que j'ai fait dans ce TP en 5 points clés.
```
C'est un excellent test de compréhension.

---

## Démos formateur avec Copilot Chat

### Démo 1 — Comprendre le state (J1, après TP1)
Ouvrir `terraform/jour1/terraform.tfstate` dans VSCode,
sélectionner tout le JSON, et dans Copilot Chat :
```
Explique ce fichier terraform.tfstate en termes simples
pour un débutant. À quoi sert chaque section ?
```

### Démo 2 — Voir la puissance des modules (J1 → J2)
Ouvrir `terraform/jour2/main.tf` et demander :
```
Ce fichier appelle le même module deux fois avec des paramètres différents.
Explique l'avantage par rapport à copier-coller le code deux fois.
```

### Démo 3 — Différence Terraform vs Ansible (transition J1/J2)
```
Dans ce projet, Terraform crée des fichiers dans output/
et Ansible génère des fichiers de config dans output/.
Quelle est la différence fondamentale entre ce que font ces deux outils ?
```

### Démo 4 — Idempotence (J2, avant TP5 Ansible)
```
Qu'est-ce que l'idempotence en Ansible ?
Donne un exemple avec le module file et montre ce qui se passe
quand on lance le playbook deux fois de suite.
```

---

## Exercices d'approfondissement générables par l'IA

Si un étudiant finit un TP en avance, lui suggérer :

### Niveau 1 — Variation simple
```
J'ai fini le TP [X] de la formation 3IAC1.
Propose-moi une variation légèrement plus difficile
en restant sur le provider local (pas de cloud).
```

### Niveau 2 — Aller plus loin
```
Le TP [X] génère [résultat].
Comment pourrais-je ajouter une validation dans Terraform
pour s'assurer que la variable environment vaut
uniquement "development", "staging" ou "production" ?
```

### Niveau 3 — Question ouverte
```
Dans un vrai projet DevOps en entreprise,
comment est-ce que le TP [X] serait différent ?
Donne un exemple concret avec Azure ou AWS.
```

---

## Ce que l'IA ne peut pas faire à votre place

- Adapter le rythme à la salle en temps réel
- Voir qu'un étudiant ne comprend pas mais ne dit rien
- Partager votre expérience terrain chez Direct Assurance / Axa
- Faire les liaisons avec les autres modules du programme B3

**Votre valeur ajoutée reste irremplaçable.**

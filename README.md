# NoSQL projet
MedSecure
# NoSQL Project - Cartographie SI avec Neo4j

## Présentation

Ce projet a été réalisé dans le cadre d’un travail sur les bases de données NoSQL, et plus précisément sur les bases orientées graphe avec Neo4j.

L’objectif est de modéliser un système d’information fictif sous forme de graphe afin d’analyser les chemins d’attaque possibles depuis une machine compromise vers des ressources sensibles.

Le scénario choisi concerne l’entreprise fictive **MedSecure**, spécialisée dans le domaine médical.

Le point d’entrée de l’attaque est le poste utilisateur **PC-NINA**, compromis à la suite d’une attaque par phishing.

---

## Objectifs du projet

Le projet permet de :

- modéliser un système d’information avec Neo4j ;
- représenter les utilisateurs, groupes, machines, services, vulnérabilités et ressources sensibles ;
- identifier les chemins d’attaque possibles ;
- analyser les machines les plus vulnérables ;
- repérer les services exposés à risque ;
- proposer des recommandations de sécurité ;
- démontrer l’impact d’une correction de sécurité.

---

## Technologies utilisées

- Neo4j AuraDB
- Cypher
- GitHub
- Markdown

---

## Modèle de données

Le graphe contient plusieurs types de nœuds :

| Type de nœud | Description |
|---|---|
| `User` | Utilisateurs du SI |
| `Group` | Groupes d’utilisateurs |
| `Machine` | Postes, serveurs, firewall, SIEM |
| `Service` | Services exposés par les machines |
| `Vulnerability` | Vulnérabilités associées aux machines |
| `Resource` | Ressources sensibles |
| `Zone` | VLAN et zones réseau |
| `Control` | Mesures de sécurité |

---

## Relations principales

| Relation | Description |
|---|---|
| `USES` | Un utilisateur utilise une machine |
| `MEMBER_OF` | Un utilisateur appartient à un groupe |
| `ADMIN_OF` | Un utilisateur administre une machine |
| `HAS_ACCESS_TO` | Un groupe a accès à une machine |
| `CONNECTED_TO` | Une machine peut communiquer avec une autre |
| `EXPOSES` | Une machine expose un service |
| `HAS_VULNERABILITY` | Une machine possède une vulnérabilité |
| `HOSTS` | Une machine héberge une ressource sensible |
| `LOCATED_IN` | Une machine appartient à une zone réseau |
| `PROTECTED_BY` | Une machine ou un utilisateur est protégé par un contrôle |

---

## Scénario d’attaque

Le scénario simulé est le suivant :

1. Le poste `PC-NINA` est compromis par phishing.
2. Depuis ce poste, l’attaquant accède à l’application médicale `SRV-EHR`.
3. L’application communique avec le serveur de base de données `SRV-MONGO`.
4. `SRV-MONGO` héberge les dossiers patients et les identités patients.
5. Une mauvaise segmentation réseau permet également à `SRV-MONGO` de communiquer avec le contrôleur de domaine `DC-MED-01`.
6. L’attaquant peut donc potentiellement atteindre Active Directory.

---

## Installation et utilisation

### 1. Créer une base Neo4j

Créer une base Neo4j, par exemple avec Neo4j AuraDB.

### 2. Exécuter le script de création

Copier le contenu du fichier suivant dans Neo4j Query :

```text
scripts/01_create_graph.cypher
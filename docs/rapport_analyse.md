
# Rapport d’analyse cyber - Projet Neo4j MedSecure

## 1. Présentation du projet

Ce projet a été réalisé dans le cadre d’un travail sur les bases de données NoSQL, avec une spécialisation sur les bases orientées graphe.

L’objectif est de modéliser un système d’information fictif à l’aide de Neo4j afin d’analyser les chemins d’attaque possibles depuis une machine compromise vers des ressources sensibles.

Le scénario choisi concerne une entreprise fictive nommée **MedSecure**, spécialisée dans le domaine médical.

Le choix du secteur médical permet de travailler sur un contexte réaliste, car ce type d’organisation manipule des données sensibles comme des dossiers patients, des identités, des sauvegardes et des secrets applicatifs.

---

## 2. Objectifs

Les objectifs du projet sont les suivants :

- créer un graphe représentant un système d’information ;
- modéliser les utilisateurs, groupes, machines, services, vulnérabilités et ressources sensibles ;
- ajouter des zones réseau et des contrôles de sécurité ;
- identifier les chemins d’attaque depuis une machine compromise ;
- analyser les vulnérabilités les plus critiques ;
- repérer les machines pivots ;
- proposer des recommandations de sécurité ;
- démontrer l’impact d’une mesure de correction.

---

## 3. Contexte du scénario

L’entreprise MedSecure possède une infrastructure composée de plusieurs zones réseau.

On retrouve notamment :

- un VLAN médical ;
- un VLAN développement ;
- une DMZ ;
- un VLAN serveurs ;
- un VLAN base de données ;
- un VLAN sauvegarde ;
- une zone Internet.

Le système d’information contient aussi plusieurs machines importantes :

- `PC-NINA` : poste utilisateur compromis ;
- `SRV-WEB-EXT` : serveur web exposé en DMZ ;
- `SRV-API` : serveur API interne ;
- `SRV-EHR` : serveur applicatif médical ;
- `SRV-MONGO` : serveur de base de données NoSQL ;
- `DC-MED-01` : contrôleur de domaine Active Directory ;
- `NAS-SAFE` : serveur de sauvegarde ;
- `FW-EDGE` : pare-feu ;
- `SIEM-01` : serveur de supervision sécurité.

Le scénario d’attaque commence par la compromission du poste `PC-NINA`.

Cette compromission est liée à une attaque de type phishing avec pièce jointe malveillante.

---

## 4. Choix de Neo4j

Neo4j est une base de données NoSQL orientée graphe.

Ce choix est adapté au projet, car un système d’information est composé de nombreuses relations.

Une base relationnelle classique permettrait de stocker ces informations dans plusieurs tables, mais l’analyse des chemins serait plus complexe.

Avec Neo4j, il est possible de représenter directement les relations entre les éléments du SI.

Par exemple :

```text
User -> Machine -> Service -> Vulnerability -> Resource
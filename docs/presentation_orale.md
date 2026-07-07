# Présentation orale - Projet Neo4j MedSecure

## 1. Introduction

Bonjour,

Nous allons vous présenter notre projet NoSQL réalisé avec Neo4j.

L’objectif du projet est de modéliser un système d’information sous forme de graphe afin d’analyser les chemins d’attaque possibles depuis une machine compromise vers des ressources sensibles.

Nous avons choisi de créer un scénario fictif autour d’une entreprise appelée **MedSecure**, spécialisée dans le domaine médical.

Dans ce scénario, le poste utilisateur **PC-NINA** est compromis à la suite d’une attaque par phishing. À partir de ce point d’entrée, nous allons montrer comment un attaquant pourrait se déplacer dans le système d’information et atteindre des ressources critiques.

---

## 2. Pourquoi utiliser Neo4j ?

Neo4j est une base de données NoSQL orientée graphe.

Contrairement à une base relationnelle classique, Neo4j permet de représenter les données sous forme de :

- nœuds ;
- relations ;
- propriétés.

Ce modèle est particulièrement adapté à la cybersécurité, car un système d’information est naturellement composé de relations.

Par exemple :

- un utilisateur utilise une machine ;
- une machine expose un service ;
- un groupe possède des droits sur un serveur ;
- un serveur héberge une ressource sensible ;
- une machine possède une vulnérabilité ;
- une machine peut communiquer avec une autre machine.

L’intérêt de Neo4j est donc de pouvoir visualiser ces relations et surtout de rechercher des chemins entre un point de départ et une cible critique.

Dans notre cas, nous cherchons à répondre à la question suivante :

> Depuis une machine compromise, quelles ressources sensibles peuvent être atteintes ?

---

## 3. Présentation du scénario

Notre scénario se déroule dans l’entreprise fictive **MedSecure**.

Cette entreprise possède :

- des postes utilisateurs ;
- des serveurs applicatifs ;
- une base de données MongoDB ;
- un contrôleur de domaine Active Directory ;
- un serveur de sauvegarde ;
- un pare-feu ;
- un SIEM ;
- plusieurs VLAN ;
- des comptes utilisateurs et des comptes de service.

Le point d’entrée de l’attaque est le poste **PC-NINA**.

Ce poste appartient au VLAN médical et est utilisé par Nina, une assistante médicale. Il est compromis à la suite d’un phishing avec une pièce jointe malveillante.

À partir de ce poste, l’attaquant peut essayer d’atteindre progressivement des machines plus sensibles.

---

## 4. Modèle de données

Dans notre graphe, nous avons créé plusieurs types de nœuds.

Les principaux nœuds sont :

- `User` : les utilisateurs du système d’information ;
- `Group` : les groupes d’utilisateurs ;
- `Machine` : les postes, serveurs, pare-feu et outils de supervision ;
- `Service` : les services exposés comme SMB, SSH, LDAP ou MongoDB ;
- `Vulnerability` : les vulnérabilités associées aux machines ;
- `Resource` : les ressources sensibles ;
- `Zone` : les VLAN et zones réseau ;
- `Control` : les mesures de sécurité comme le MFA, l’EDR ou le SIEM.

Nous avons également créé plusieurs relations :

- `USES` : un utilisateur utilise une machine ;
- `MEMBER_OF` : un utilisateur appartient à un groupe ;
- `ADMIN_OF` : un utilisateur administre une machine ;
- `HAS_ACCESS_TO` : un groupe a accès à une machine ;
- `CONNECTED_TO` : une machine peut communiquer avec une autre ;
- `EXPOSES` : une machine expose un service ;
- `HAS_VULNERABILITY` : une machine possède une vulnérabilité ;
- `HOSTS` : une machine héberge une ressource sensible ;
- `LOCATED_IN` : une machine appartient à une zone réseau ;
- `PROTECTED_BY` : une machine ou un utilisateur est protégé par une mesure de sécurité.

Ce modèle permet d’avoir une vue complète du système d’information et de ses dépendances.

---

## 5. Démonstration 1 - Affichage du graphe complet

Pour commencer, nous affichons tout le graphe avec la requête suivante :

```cypher
MATCH (n)
RETURN n;
# Rapport d’analyse cyber - Projet Neo4j MedSecure

## 1. Présentation du projet

Ce projet a été réalisé dans le cadre d’un travail sur les bases de données NoSQL, avec une spécialisation sur les bases orientées graphe.

L’objectif est de modéliser un système d’information fictif à l’aide de **Neo4j** afin d’analyser les chemins d’attaque possibles depuis une machine compromise vers des ressources sensibles.

Le scénario choisi concerne une entreprise fictive nommée **MedSecure**, spécialisée dans le domaine médical.

Ce contexte est intéressant car une entreprise médicale manipule des données sensibles comme :

- des dossiers patients ;
- des identités patients ;
- des sauvegardes ;
- des secrets applicatifs ;
- des logs de sécurité ;
- un annuaire Active Directory.

Le projet permet donc de montrer comment Neo4j peut être utilisé pour cartographier un système d’information et analyser les risques cyber.

---

## 2. Objectifs du projet

Les objectifs du projet sont les suivants :

- créer un graphe représentant un système d’information ;
- modéliser les utilisateurs, groupes, machines, services, vulnérabilités et ressources sensibles ;
- ajouter des zones réseau et des contrôles de sécurité ;
- identifier les chemins d’attaque depuis une machine compromise ;
- analyser les vulnérabilités les plus critiques ;
- repérer les machines pivots ;
- identifier les comptes sensibles ;
- proposer des recommandations de sécurité ;
- démontrer l’impact d’une mesure de correction.

---

## 3. Contexte du scénario

L’entreprise MedSecure possède une infrastructure composée de plusieurs zones réseau.

Les principales zones modélisées sont :

| Zone | Description | Niveau de confiance |
|---|---|---|
| `VLAN-MEDICAL` | Postes du personnel médical | Faible |
| `VLAN-DEV` | Postes développeurs | Moyen |
| `DMZ` | Serveurs exposés | Moyen |
| `VLAN-SERVERS` | Serveurs internes | Élevé |
| `VLAN-DATABASE` | Bases de données | Critique |
| `VLAN-BACKUP` | Sauvegardes | Critique |
| `INTERNET` | Réseau externe | Non fiable |

Le système d’information contient plusieurs machines importantes.

| Machine | Rôle |
|---|---|
| `PC-NINA` | Poste utilisateur compromis |
| `PC-LEO` | Poste utilisateur médical |
| `PC-PAUL` | Poste développeur |
| `SRV-WEB-EXT` | Serveur web exposé en DMZ |
| `SRV-API` | Serveur API interne |
| `SRV-EHR` | Serveur applicatif médical |
| `SRV-MONGO` | Serveur de base de données NoSQL |
| `DC-MED-01` | Contrôleur de domaine Active Directory |
| `NAS-SAFE` | Serveur de sauvegarde |
| `FW-EDGE` | Pare-feu |
| `SIEM-01` | Serveur de supervision sécurité |

Le scénario d’attaque commence par la compromission du poste `PC-NINA`.

Cette compromission est liée à une attaque de type phishing avec une pièce jointe malveillante.

---

## 4. Choix de Neo4j

Neo4j est une base de données NoSQL orientée graphe.

Ce choix est adapté au projet car un système d’information est composé de nombreuses relations.

Une base relationnelle classique permettrait de stocker ces informations dans plusieurs tables, mais l’analyse des chemins serait plus complexe.

Avec Neo4j, les relations sont au cœur du modèle.

Par exemple, on peut représenter directement les liens suivants :

```text
Utilisateur -> Machine -> Service -> Vulnérabilité -> Ressource sensible
```

Neo4j est donc utile pour la cybersécurité car il permet de répondre à des questions comme :

- quelles machines sont accessibles depuis un poste compromis ?
- quelles ressources sensibles peuvent être atteintes ?
- quel est le chemin le plus court vers Active Directory ?
- quelles machines possèdent les vulnérabilités les plus critiques ?
- quelles machines peuvent servir de pivots ?
- quelles mesures de sécurité réduisent les chemins d’attaque ?

---

## 5. Modèle de données

Le graphe est composé de plusieurs types de nœuds.

| Type de nœud | Rôle |
|---|---|
| `User` | Représente les utilisateurs et comptes de service |
| `Group` | Représente les groupes d’utilisateurs |
| `Machine` | Représente les postes, serveurs, pare-feu et outils sécurité |
| `Service` | Représente les services exposés |
| `Vulnerability` | Représente les vulnérabilités |
| `Resource` | Représente les ressources sensibles |
| `Zone` | Représente les VLAN ou zones réseau |
| `Control` | Représente les mesures de sécurité |

Chaque nœud possède des propriétés.

Exemple pour une machine :

```text
name: PC-NINA
type: workstation
os: Windows 10
ip: 10.10.10.21
vlan: VLAN-MEDICAL
criticality: low
compromised: true
```

Exemple pour une vulnérabilité :

```text
cve: CVE-2024-0002
name: Weak Password Policy
severity: high
score: 8.1
category: Identity
```

---

## 6. Relations utilisées

Le graphe utilise plusieurs relations.

| Relation | Description |
|---|---|
| `USES` | Un utilisateur utilise une machine |
| `MEMBER_OF` | Un utilisateur appartient à un groupe |
| `ADMIN_OF` | Un utilisateur administre une machine |
| `HAS_ACCESS_TO` | Un groupe possède un accès à une machine |
| `CONNECTED_TO` | Une machine peut communiquer avec une autre |
| `EXPOSES` | Une machine expose un service |
| `HAS_VULNERABILITY` | Une machine possède une vulnérabilité |
| `HOSTS` | Une machine héberge une ressource sensible |
| `LOCATED_IN` | Une machine appartient à une zone réseau |
| `PROTECTED_BY` | Une machine ou un utilisateur est protégé par une mesure |

Ces relations permettent d’obtenir une vue réaliste du système d’information.

Elles permettent aussi d’analyser les chemins d’attaque en partant d’une machine compromise.

---

## 7. Ressources sensibles

Les ressources sensibles modélisées sont les suivantes.

| Ressource | Sensibilité | Description |
|---|---|---|
| `Dossiers patients` | Critique | Données médicales confidentielles |
| `Identités patients` | Élevée | Informations personnelles des patients |
| `Active Directory` | Critique | Annuaire central et authentification |
| `Sauvegardes médicales` | Critique | Sauvegardes des données importantes |
| `Secrets API` | Critique | Tokens, clés API et identifiants |
| `Logs sécurité` | Élevée | Journaux de sécurité et supervision |

Ces ressources sont prioritaires car leur compromission pourrait avoir un impact important sur l’entreprise.

---

## 8. Point d’entrée de l’attaque

Le point d’entrée est la machine `PC-NINA`.

Cette machine possède les caractéristiques suivantes :

| Élément | Valeur |
|---|---|
| Nom | `PC-NINA` |
| Type | `workstation` |
| OS | `Windows 10` |
| VLAN | `VLAN-MEDICAL` |
| IP | `10.10.10.21` |
| Statut | Compromise |
| Vecteur d’attaque | Phishing |
| Incident | Poste utilisateur compromis |

La compromission d’un poste utilisateur est un scénario réaliste.

Même si le poste n’est pas critique au départ, il peut devenir dangereux s’il possède des accès vers des applications internes.

---

## 9. Chemin d’attaque principal

Le chemin d’attaque principal identifié est le suivant :

```text
PC-NINA -> SRV-EHR -> SRV-MONGO -> DC-MED-01 -> Active Directory
```

### Explication du chemin

1. L’attaquant compromet `PC-NINA`.
2. Depuis ce poste, il accède à l’application médicale `SRV-EHR`.
3. `SRV-EHR` communique avec `SRV-MONGO`.
4. `SRV-MONGO` héberge les dossiers patients et les identités patients.
5. `SRV-MONGO` possède aussi un flux vers `DC-MED-01`.
6. L’attaquant peut donc potentiellement atteindre Active Directory.

Ce chemin met en évidence un problème de segmentation réseau.

Un serveur de base de données ne devrait pas pouvoir communiquer trop largement avec le contrôleur de domaine.

---

## 10. Requêtes Cypher principales

### 10.1 Afficher tout le graphe

```cypher
MATCH (n)
RETURN n;
```

Cette requête permet de visualiser l’ensemble des nœuds et relations.

---

### 10.2 Vérifier les volumes du graphe

```cypher
MATCH (n)
RETURN labels(n)[0] AS type_de_noeud, count(n) AS nombre
ORDER BY type_de_noeud;
```

Cette requête permet de vérifier le nombre de nœuds par type.

Elle permet de prouver que le graphe contient suffisamment d’éléments pour répondre aux consignes.

---

### 10.3 Trouver les chemins d’attaque depuis PC-NINA

```cypher
MATCH path = (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine)-[:HOSTS]->(:Resource)
RETURN path;
```

Cette requête affiche tous les chemins possibles depuis la machine compromise vers les ressources sensibles.

---

### 10.4 Trouver les ressources critiques accessibles

```cypher
MATCH path = (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(m:Machine)-[:HOSTS]->(r:Resource)
WHERE r.sensitivity = "critical"
RETURN r.name AS ressource_critique,
       m.name AS machine_hote,
       m.vlan AS vlan_machine,
       length(path) AS distance_depuis_pc_nina,
       path
ORDER BY distance_depuis_pc_nina ASC;
```

Cette requête permet de filtrer uniquement les ressources critiques.

Elle permet de prioriser les risques.

---

### 10.5 Trouver le chemin le plus court vers Active Directory

```cypher
MATCH path = shortestPath(
  (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine {name: "DC-MED-01"})
)
RETURN path;
```

Cette requête permet d’identifier le chemin le plus direct vers le contrôleur de domaine.

---

### 10.6 Identifier les vulnérabilités critiques

```cypher
MATCH (m:Machine)-[:HAS_VULNERABILITY]->(v:Vulnerability)
WHERE v.score >= 9
RETURN m.name AS machine,
       m.type AS type,
       m.vlan AS vlan,
       m.criticality AS criticite_machine,
       v.cve AS cve,
       v.name AS vulnerabilite,
       v.score AS score_cvss,
       v.severity AS severite
ORDER BY v.score DESC;
```

Cette requête permet d’identifier les machines à corriger en priorité.

---

### 10.7 Calculer un score de risque par machine

```cypher
MATCH (m:Machine)-[:HAS_VULNERABILITY]->(v:Vulnerability)
RETURN m.name AS machine,
       m.vlan AS vlan,
       m.criticality AS criticite,
       count(v) AS nombre_vulnerabilites,
       round(sum(v.score), 2) AS score_risque_total,
       round(avg(v.score), 2) AS score_moyen
ORDER BY score_risque_total DESC;
```

Cette requête donne une vision synthétique du risque par machine.

---

### 10.8 Identifier les machines pivots

```cypher
MATCH (m:Machine)-[:CONNECTED_TO]->(target:Machine)
RETURN m.name AS machine_pivot,
       m.vlan AS vlan,
       count(target) AS connexions_sortantes,
       collect(target.name) AS machines_accessibles
ORDER BY connexions_sortantes DESC;
```

Cette requête permet de repérer les machines qui donnent accès à plusieurs autres machines.

---

### 10.9 Identifier les services dangereux exposés

```cypher
MATCH (m:Machine)-[:EXPOSES]->(s:Service)
WHERE s.risk IN ["high", "medium"]
RETURN m.name AS machine,
       m.vlan AS vlan,
       m.criticality AS criticite_machine,
       s.name AS service,
       s.port AS port,
       s.risk AS niveau_risque
ORDER BY s.risk DESC, m.criticality DESC;
```

Cette requête permet d’identifier les services à surveiller ou filtrer.

---

### 10.10 Identifier les comptes sans MFA

```cypher
MATCH (u:User)
WHERE u.mfa_enabled = false
RETURN u.name AS utilisateur,
       u.role AS role,
       u.privilege AS privilege,
       u.risk_level AS niveau_risque
ORDER BY u.risk_level DESC;
```

Cette requête permet de repérer les comptes nécessitant un renforcement de sécurité.

---

### 10.11 Identifier les vulnérabilités sur les chemins critiques

```cypher
MATCH path = (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(m:Machine)-[:HOSTS]->(r:Resource)
WHERE r.sensitivity = "critical"
WITH r, nodes(path) AS machines_du_chemin
UNWIND machines_du_chemin AS machine
MATCH (machine)-[:HAS_VULNERABILITY]->(v:Vulnerability)
RETURN DISTINCT r.name AS ressource_critique,
       machine.name AS machine_vulnerable,
       machine.vlan AS vlan,
       v.cve AS cve,
       v.name AS vulnerabilite,
       v.score AS score
ORDER BY score DESC;
```

Cette requête permet de comprendre pourquoi certains chemins d’attaque sont dangereux.

Elle associe les chemins vers les ressources critiques avec les vulnérabilités présentes sur les machines traversées.

---

## 11. Analyse des vulnérabilités

Plusieurs vulnérabilités ont été modélisées dans le graphe.

| Vulnérabilité | Score | Risque |
|---|---:|---|
| Log4Shell | 10.0 | Critique |
| Zerologon | 10.0 | Critique |
| BlueKeep | 9.8 | Critique |
| Spring4Shell | 9.8 | Critique |
| MongoDB Without Authentication | 9.1 | Critique |
| Exposed Admin Panel | 8.8 | Élevé |
| Weak Password Policy | 8.1 | Élevé |
| SMB Misconfiguration | 7.5 | Élevé |

Les vulnérabilités les plus critiques peuvent permettre :

- une exécution de code à distance ;
- une élévation de privilèges ;
- un accès non autorisé à des données ;
- un déplacement latéral ;
- une compromission du domaine.

Les machines ayant des vulnérabilités critiques doivent être corrigées en priorité.

---

## 12. Analyse des services exposés

Les services les plus sensibles dans le graphe sont les suivants.

| Service | Port | Risque |
|---|---:|---|
| SMB | 445 | Élevé |
| RDP | 3389 | Élevé |
| LDAP | 389 | Élevé |
| Kerberos | 88 | Élevé |
| MongoDB | 27017 | Élevé |
| SSH | 22 | Moyen |
| HTTP | 80 | Moyen |

Ces services doivent être contrôlés et filtrés.

Un service comme SMB, LDAP ou MongoDB ne devrait pas être accessible depuis n’importe quelle zone réseau.

---

## 13. Analyse des comptes

Le graphe distingue plusieurs profils :

- utilisateurs standards ;
- utilisateurs limités ;
- administrateurs ;
- responsables sécurité ;
- comptes de service.

Les comptes de service sont particulièrement sensibles.

Dans le scénario, `svc_app` et `svc_backup` possèdent des privilèges élevés.

Ils ne disposent pas de MFA, ce qui représente un risque important.

Un attaquant qui récupère ces identifiants pourrait accéder à des ressources critiques comme les serveurs applicatifs ou les sauvegardes.

---

## 14. Analyse des machines pivots

Une machine pivot est une machine qui permet d’accéder à plusieurs autres machines.

Dans notre scénario, les machines comme `SRV-EHR`, `SRV-API` et `SRV-MONGO` sont importantes, car elles se situent sur des chemins vers des ressources sensibles.

Ces machines doivent être :

- surveillées ;
- journalisées ;
- corrigées rapidement ;
- protégées par des règles réseau strictes.

---

## 15. Démonstration avant / après correction

Pour montrer l’intérêt de l’analyse graphe, nous avons simulé une mesure de correction.

### 15.1 Avant correction

Avant correction, il existe un chemin entre `PC-NINA` et `DC-MED-01`.

```cypher
MATCH path = shortestPath(
  (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine {name: "DC-MED-01"})
)
RETURN path;
```

Ce chemin montre que l’attaquant peut potentiellement atteindre Active Directory.

### 15.2 Correction appliquée

La correction consiste à supprimer le flux LDAP entre `SRV-MONGO` et `DC-MED-01`.

```cypher
MATCH (:Machine {name: "SRV-MONGO"})-[r:CONNECTED_TO]->(:Machine {name: "DC-MED-01"})
DELETE r;
```

Cette correction représente une règle de segmentation réseau.

L’objectif est d’empêcher la base de données de communiquer directement avec le contrôleur de domaine.

### 15.3 Après correction

Après correction, nous vérifions si le chemin existe encore.

```cypher
MATCH path = shortestPath(
  (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine {name: "DC-MED-01"})
)
RETURN path;
```

Après suppression du flux, le chemin direct vers Active Directory disparaît.

Cela montre que la segmentation réseau réduit le risque de déplacement latéral.

### 15.4 Remise en état

Pour rejouer la démonstration, il est possible de recréer la relation supprimée.

```cypher
MATCH (a:Machine {name: "SRV-MONGO"}), (b:Machine {name: "DC-MED-01"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "LDAP",
  port: 389,
  rule: "Authentification LDAP",
  allowed: true,
  risk: "high"
}]->(b);
```

---

## 16. Recommandations de sécurité

À partir de l’analyse, les recommandations sont les suivantes.

### 16.1 Renforcer la segmentation réseau

Il faut limiter les flux entre les VLAN.

Les postes utilisateurs ne doivent pas pouvoir accéder directement aux zones sensibles.

Les flux entre les serveurs doivent être justifiés et documentés.

---

### 16.2 Supprimer les flux inutiles vers Active Directory

Active Directory doit être isolé autant que possible.

Les flux vers le contrôleur de domaine doivent être strictement nécessaires.

Le flux entre `SRV-MONGO` et `DC-MED-01` doit être supprimé ou très fortement contrôlé.

---

### 16.3 Corriger les vulnérabilités critiques

Les vulnérabilités avec un score CVSS supérieur ou égal à 9 doivent être corrigées en priorité.

Cela concerne notamment :

- Log4Shell ;
- Zerologon ;
- Spring4Shell ;
- BlueKeep ;
- MongoDB sans authentification forte.

---

### 16.4 Activer le MFA

Le MFA doit être activé sur les comptes sensibles.

Cela concerne en priorité :

- les administrateurs ;
- les responsables sécurité ;
- les utilisateurs ayant accès à des données sensibles.

Pour les comptes de service, il faut utiliser des mécanismes adaptés comme :

- rotation des secrets ;
- mots de passe complexes ;
- coffre-fort de secrets ;
- restriction des droits ;
- surveillance des usages.

---

### 16.5 Limiter les comptes de service

Les comptes de service doivent respecter le principe du moindre privilège.

Ils ne doivent avoir accès qu’aux ressources nécessaires.

Il faut également éviter qu’un même compte de service soit utilisé sur plusieurs machines critiques.

---

### 16.6 Surveiller les machines pivots

Les machines situées sur les chemins d’attaque doivent être surveillées avec le SIEM.

Il faut journaliser :

- les connexions administrateur ;
- les échecs d’authentification ;
- les connexions anormales ;
- les accès aux ressources sensibles ;
- les modifications de configuration.

---

### 16.7 Réduire les services exposés

Les services comme SMB, RDP, LDAP, SSH et MongoDB doivent être filtrés.

Ils ne doivent pas être accessibles depuis des zones non autorisées.

Il faut appliquer une logique de liste blanche, c’est-à-dire autoriser uniquement les flux nécessaires.

---

### 16.8 Améliorer la politique de mots de passe

La politique de mots de passe doit être renforcée.

Elle doit inclure :

- une longueur minimale suffisante ;
- l’interdiction des mots de passe faibles ;
- la détection des mots de passe compromis ;
- une gestion sécurisée des comptes à privilèges ;
- une rotation adaptée pour les secrets techniques.

---

## 17. Limites du projet

Le projet reste une simulation.

Il ne représente pas un système d’information réel complet.

Certaines vulnérabilités sont utilisées pour illustrer les risques.

Le modèle pourrait être enrichi avec :

- des données de scan réelles ;
- des règles de pare-feu détaillées ;
- des niveaux de privilèges plus précis ;
- une pondération plus avancée du risque ;
- des dates de correctifs ;
- des événements issus d’un SIEM ;
- des chemins d’attaque avec probabilité et impact ;
- des informations issues d’un annuaire réel.

---

## 18. Conclusion

Ce projet montre l’intérêt de Neo4j pour l’analyse cyber.

Le modèle graphe permet de visualiser les relations entre :

- les utilisateurs ;
- les machines ;
- les services ;
- les vulnérabilités ;
- les ressources sensibles ;
- les zones réseau ;
- les contrôles de sécurité.

Il permet aussi d’identifier les chemins d’attaque possibles depuis une machine compromise.

Dans notre scénario, le poste `PC-NINA` peut mener à des ressources critiques comme les dossiers patients, la base MongoDB et Active Directory.

La démonstration avant / après segmentation montre que la suppression d’un flux réseau peut réduire fortement le risque.

Neo4j est donc un outil intéressant pour cartographier un système d’information, comprendre les dépendances et prioriser les actions de sécurité.
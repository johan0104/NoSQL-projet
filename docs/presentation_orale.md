# Présentation orale - Projet Neo4j MedSecure

## 1. Introduction

Bonjour,

Nous allons vous présenter notre projet NoSQL réalisé avec **Neo4j**.

L’objectif de ce projet est de modéliser un système d’information sous forme de graphe afin d’analyser les chemins d’attaque possibles depuis une machine compromise vers des ressources sensibles.

Nous avons choisi de créer un scénario fictif autour d’une entreprise appelée **MedSecure**, spécialisée dans le domaine médical.

Dans notre scénario, le poste utilisateur **PC-NINA** est compromis à la suite d’une attaque par phishing. À partir de ce point d’entrée, nous allons montrer comment un attaquant pourrait se déplacer dans le système d’information et atteindre des ressources critiques comme les dossiers patients ou Active Directory.

---

## 2. Pourquoi utiliser Neo4j ?

Neo4j est une base de données NoSQL orientée graphe.

Contrairement à une base de données relationnelle classique, Neo4j permet de représenter les données sous forme de :

- nœuds ;
- relations ;
- propriétés.

Ce modèle est particulièrement adapté à la cybersécurité, car un système d’information est naturellement composé de relations.

Par exemple :

- un utilisateur utilise une machine ;
- une machine expose un service ;
- une machine possède une vulnérabilité ;
- un groupe possède des droits sur un serveur ;
- une machine peut communiquer avec une autre machine ;
- un serveur héberge une ressource sensible.

L’intérêt de Neo4j est donc de pouvoir visualiser facilement ces relations et surtout de rechercher des chemins d’attaque.

La question principale de notre projet est donc :

> Depuis une machine compromise, quelles ressources sensibles peuvent être atteintes ?

---

## 3. Présentation du scénario

Notre scénario se déroule dans une entreprise fictive appelée **MedSecure**.

Il s’agit d’une entreprise du domaine médical qui possède plusieurs ressources sensibles :

- des dossiers patients ;
- des identités patients ;
- un Active Directory ;
- des sauvegardes médicales ;
- des secrets API ;
- des logs de sécurité.

Le point d’entrée de l’attaque est la machine **PC-NINA**.

Cette machine est utilisée par une assistante médicale. Elle est compromise à la suite d’une attaque par phishing avec une pièce jointe malveillante.

L’objectif de l’analyse est de savoir si un attaquant peut, depuis ce poste utilisateur, atteindre des serveurs critiques ou des données sensibles.

---

## 4. Modèle de données

Dans notre graphe, nous avons créé plusieurs types de nœuds.

| Type de nœud | Description |
|---|---|
| `User` | Utilisateurs et comptes de service |
| `Group` | Groupes d’utilisateurs |
| `Machine` | Postes, serveurs, pare-feu et SIEM |
| `Service` | Services exposés comme SSH, SMB, LDAP ou MongoDB |
| `Vulnerability` | Vulnérabilités associées aux machines |
| `Resource` | Ressources sensibles |
| `Zone` | VLAN et zones réseau |
| `Control` | Mesures de sécurité comme MFA, EDR ou SIEM |

Nous avons également créé plusieurs relations.

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

Ce modèle permet d’avoir une vue complète du système d’information et de ses dépendances.

---

## 5. Démonstration 1 - Affichage du graphe complet

Pour commencer, nous affichons tout le graphe avec la requête suivante :

```cypher
MATCH (n)
RETURN n;
```

Cette requête permet de visualiser l’ensemble du système d’information.

On retrouve :

- les utilisateurs ;
- les groupes ;
- les machines ;
- les services ;
- les vulnérabilités ;
- les ressources sensibles ;
- les VLAN ;
- les contrôles de sécurité.

Cette première vue donne une vision globale de l’infrastructure.

---

## 6. Démonstration 2 - Vérification des volumes du graphe

Nous pouvons ensuite vérifier le nombre de nœuds par type.

```cypher
MATCH (n)
RETURN labels(n)[0] AS type_de_noeud, count(n) AS nombre
ORDER BY type_de_noeud;
```

Cette requête permet de vérifier que le graphe respecte bien les consignes du projet.

Elle montre le nombre d’éléments créés pour chaque type de nœud.

Notre projet va plus loin que le minimum demandé, car nous avons ajouté :

- des zones réseau ;
- des contrôles de sécurité ;
- des comptes de service ;
- des niveaux de criticité ;
- des vulnérabilités avec score CVSS ;
- des relations réseau permettant d’analyser les chemins d’attaque.

---

## 7. Démonstration 3 - Identification de la machine compromise

Nous identifions maintenant la machine compromise.

```cypher
MATCH (m:Machine)
WHERE m.compromised = true
RETURN m.name AS machine_compromise,
       m.ip AS adresse_ip,
       m.vlan AS vlan,
       m.attack_vector AS vecteur_attaque,
       m.incident AS incident;
```

Le résultat montre que la machine compromise est **PC-NINA**.

Elle se trouve dans le VLAN médical et le vecteur d’attaque est un phishing.

Cette étape permet de définir clairement le point de départ de notre scénario d’attaque.

---

## 8. Démonstration 4 - Chemins d’attaque vers les ressources sensibles

La requête suivante permet d’afficher les chemins possibles depuis `PC-NINA` vers les ressources sensibles.

```cypher
MATCH path = (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine)-[:HOSTS]->(:Resource)
RETURN path;
```

Cette requête est centrale dans notre projet.

Elle permet de montrer comment un attaquant peut se déplacer depuis une machine utilisateur compromise vers des serveurs internes.

Dans notre scénario, le chemin principal est :

```text
PC-NINA -> SRV-EHR -> SRV-MONGO -> DC-MED-01 -> Active Directory
```

Cela montre qu’un simple poste utilisateur peut devenir un point d’entrée vers des ressources critiques si les flux réseau sont trop permissifs.

---

## 9. Démonstration 5 - Ressources critiques accessibles

Nous pouvons ensuite filtrer uniquement les ressources critiques accessibles depuis `PC-NINA`.

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

Cette requête permet de prioriser les ressources les plus importantes.

Les ressources critiques sont celles dont la compromission aurait le plus fort impact sur l’entreprise.

Dans notre cas, on retrouve notamment :

- les dossiers patients ;
- Active Directory ;
- les sauvegardes médicales ;
- les secrets API.

---

## 10. Démonstration 6 - Chemin le plus court vers Active Directory

Active Directory est une cible prioritaire pour un attaquant, car il permet de contrôler l’authentification et les droits dans le domaine.

Nous recherchons donc le chemin le plus court entre `PC-NINA` et le contrôleur de domaine `DC-MED-01`.

```cypher
MATCH path = shortestPath(
  (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine {name: "DC-MED-01"})
)
RETURN path;
```

Cette requête permet de visualiser le chemin le plus direct entre le poste compromis et le contrôleur de domaine.

Dans notre modèle, cela met en évidence une mauvaise segmentation entre le serveur MongoDB et Active Directory.

---

## 11. Démonstration 7 - Machines avec vulnérabilités critiques

Nous pouvons afficher les machines qui possèdent des vulnérabilités critiques.

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

Cette requête permet de prioriser les corrections.

Les vulnérabilités avec un score CVSS supérieur ou égal à 9 sont les plus critiques.

Elles peuvent permettre :

- une exécution de code à distance ;
- une élévation de privilèges ;
- un accès non autorisé ;
- un déplacement latéral ;
- une compromission de ressources sensibles.

---

## 12. Démonstration 8 - Score de risque par machine

Nous avons aussi créé une requête qui calcule un score de risque simple par machine.

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

Le principe est d’additionner les scores CVSS des vulnérabilités présentes sur chaque machine.

Ce n’est pas un score de risque complet comme dans un outil professionnel, mais cela permet de prioriser les machines à corriger en premier.

---

## 13. Démonstration 9 - Identification des machines pivots

Une machine pivot est une machine qui permet d’accéder à plusieurs autres machines.

Dans une attaque, ces machines sont importantes car elles facilitent le déplacement latéral.

```cypher
MATCH (m:Machine)-[:CONNECTED_TO]->(target:Machine)
RETURN m.name AS machine_pivot,
       m.vlan AS vlan,
       count(target) AS connexions_sortantes,
       collect(target.name) AS machines_accessibles
ORDER BY connexions_sortantes DESC;
```

Cette requête permet d’identifier les machines à surveiller en priorité.

Une machine pivot doit être protégée, journalisée et surveillée par le SIEM.

---

## 14. Démonstration 10 - Services dangereux exposés

Nous pouvons afficher les services à risque exposés par les machines.

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

Les services comme SMB, RDP, LDAP, MongoDB ou SSH doivent être surveillés attentivement.

Ils ne sont pas forcément dangereux par nature, mais ils peuvent devenir critiques s’ils sont exposés trop largement ou mal configurés.

---

## 15. Démonstration 11 - Comptes sans MFA

Nous analysons maintenant les comptes sans MFA.

```cypher
MATCH (u:User)
WHERE u.mfa_enabled = false
RETURN u.name AS utilisateur,
       u.role AS role,
       u.privilege AS privilege,
       u.risk_level AS niveau_risque
ORDER BY u.risk_level DESC;
```

Cette requête met en évidence les comptes plus fragiles.

Dans notre scénario, certains utilisateurs et comptes de service n’ont pas de MFA.

Cela augmente le risque de compromission, surtout si ces comptes possèdent des privilèges élevés.

---

## 16. Démonstration 12 - Vulnérabilités présentes sur les chemins critiques

Cette requête permet d’aller plus loin.

Elle affiche les vulnérabilités présentes sur les machines qui se trouvent sur un chemin vers une ressource critique.

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

Cette requête est intéressante car elle ne se contente pas de trouver un chemin.

Elle montre aussi pourquoi ce chemin est dangereux, en affichant les vulnérabilités présentes sur les machines traversées.

---

## 17. Démonstration bonus - Avant / après segmentation réseau

Pour montrer l’intérêt de l’analyse avec Neo4j, nous avons simulé une correction de sécurité.

### 17.1 Avant correction

Avant correction, il existe un chemin entre `PC-NINA` et `DC-MED-01`.

```cypher
MATCH path = shortestPath(
  (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine {name: "DC-MED-01"})
)
RETURN path;
```

### 17.2 Correction appliquée

Nous supprimons le flux risqué entre `SRV-MONGO` et `DC-MED-01`.

```cypher
MATCH (:Machine {name: "SRV-MONGO"})-[r:CONNECTED_TO]->(:Machine {name: "DC-MED-01"})
DELETE r;
```

Cette correction simule une règle de segmentation réseau.

Le serveur MongoDB ne doit pas pouvoir communiquer directement avec le contrôleur de domaine.

### 17.3 Après correction

Nous relançons ensuite la recherche du chemin vers Active Directory.

```cypher
MATCH path = shortestPath(
  (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine {name: "DC-MED-01"})
)
RETURN path;
```

Après correction, le chemin direct vers Active Directory disparaît.

Cela montre que la segmentation réseau réduit le risque de déplacement latéral.

### 17.4 Remise en état pour refaire la démonstration

Si besoin, on peut remettre la relation supprimée avec cette requête.

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

## 18. Recommandations

À partir de notre analyse, nous proposons plusieurs recommandations.

### 18.1 Renforcer la segmentation réseau

Il faut limiter les flux entre les VLAN.

Les postes utilisateurs ne doivent pas pouvoir accéder directement aux zones sensibles.

### 18.2 Supprimer les flux inutiles vers Active Directory

Active Directory doit être isolé autant que possible.

Les flux vers le contrôleur de domaine doivent être strictement nécessaires et contrôlés.

### 18.3 Corriger les vulnérabilités critiques

Les vulnérabilités avec un score CVSS supérieur ou égal à 9 doivent être corrigées en priorité.

### 18.4 Activer le MFA

Le MFA doit être activé pour les comptes utilisateurs sensibles et les administrateurs.

Les comptes de service doivent être protégés par d’autres mécanismes adaptés.

### 18.5 Limiter les droits des comptes de service

Les comptes de service doivent respecter le principe du moindre privilège.

Ils ne doivent avoir que les droits strictement nécessaires.

### 18.6 Surveiller les machines pivots

Les machines situées sur les chemins d’attaque doivent être surveillées en priorité avec le SIEM.

### 18.7 Réduire les services exposés

Les services comme SMB, RDP, LDAP, SSH et MongoDB doivent être filtrés.

Ils ne doivent pas être accessibles depuis des zones non autorisées.

---

## 19. Conclusion

Pour conclure, ce projet montre l’intérêt de Neo4j dans un contexte cybersécurité.

Grâce au modèle graphe, on ne se limite pas à une simple liste de machines ou de vulnérabilités.

On peut analyser les relations entre les composants du système d’information et visualiser les chemins d’attaque possibles.

Neo4j permet donc :

- d’identifier les ressources critiques accessibles ;
- de repérer les machines vulnérables ;
- de détecter les machines pivots ;
- de prioriser les corrections ;
- de tester l’impact d’une mesure de sécurité.

Ce type d’approche peut aider une équipe informatique ou cybersécurité à mieux comprendre son exposition au risque et à prendre de meilleures décisions.
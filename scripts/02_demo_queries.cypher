// Afficher tout le graphe
MATCH (n)
RETURN n;

// Vérifier les volumes du graphe
MATCH (n)
RETURN labels(n)[0] AS type_de_noeud, count(n) AS nombre
ORDER BY type_de_noeud;

// Voir la machine compromise
MATCH (m:Machine)
WHERE m.compromised = true
RETURN m.name AS machine_compromise,
       m.ip AS adresse_ip,
       m.vlan AS vlan,
       m.attack_vector AS vecteur_attaque,
       m.incident AS incident;

// Chemins d’attaque depuis PC-NINA vers les ressources sensibles
MATCH path = (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine)-[:HOSTS]->(:Resource)
RETURN path;

// Ressources critiques accessibles depuis PC-NINA
MATCH path = (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(m:Machine)-[:HOSTS]->(r:Resource)
WHERE r.sensitivity = "critical"
RETURN r.name AS ressource_critique,
       m.name AS machine_hote,
       m.vlan AS vlan_machine,
       length(path) AS distance_depuis_pc_nina,
       path
ORDER BY distance_depuis_pc_nina ASC;

// Chemin le plus court vers Active Directory
MATCH path = shortestPath(
  (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine {name: "DC-MED-01"})
)
RETURN path;

// Machines avec vulnérabilités critiques
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

// Score de risque par machine
MATCH (m:Machine)-[:HAS_VULNERABILITY]->(v:Vulnerability)
RETURN m.name AS machine,
       m.vlan AS vlan,
       m.criticality AS criticite,
       count(v) AS nombre_vulnerabilites,
       round(sum(v.score), 2) AS score_risque_total,
       round(avg(v.score), 2) AS score_moyen
ORDER BY score_risque_total DESC;

// Machines pivots
MATCH (m:Machine)-[:CONNECTED_TO]->(target:Machine)
RETURN m.name AS machine_pivot,
       m.vlan AS vlan,
       count(target) AS connexions_sortantes,
       collect(target.name) AS machines_accessibles
ORDER BY connexions_sortantes DESC;

// Services dangereux exposés
MATCH (m:Machine)-[:EXPOSES]->(s:Service)
WHERE s.risk IN ["high", "medium"]
RETURN m.name AS machine,
       m.vlan AS vlan,
       m.criticality AS criticite_machine,
       s.name AS service,
       s.port AS port,
       s.risk AS niveau_risque
ORDER BY s.risk DESC, m.criticality DESC;

// Comptes sans MFA
MATCH (u:User)
WHERE u.mfa_enabled = false
RETURN u.name AS utilisateur,
       u.role AS role,
       u.privilege AS privilege,
       u.risk_level AS niveau_risque
ORDER BY u.risk_level DESC;
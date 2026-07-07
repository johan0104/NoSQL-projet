// =======================================================
// Démonstration avant / après segmentation réseau
// =======================================================

// 1. Avant correction : vérifier le chemin vers Active Directory

MATCH path = shortestPath(
  (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine {name: "DC-MED-01"})
)
RETURN path;


// 2. Correction : supprimer le flux risqué entre SRV-MONGO et DC-MED-01

MATCH (:Machine {name: "SRV-MONGO"})-[r:CONNECTED_TO]->(:Machine {name: "DC-MED-01"})
DELETE r;


// 3. Après correction : vérifier que le chemin a disparu

MATCH path = shortestPath(
  (:Machine {name: "PC-NINA"})-[:CONNECTED_TO*1..6]->(:Machine {name: "DC-MED-01"})
)
RETURN path;


// 4. Remise en état pour refaire la démo si nécessaire

MATCH (a:Machine {name: "SRV-MONGO"}), (b:Machine {name: "DC-MED-01"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "LDAP",
  port: 389,
  rule: "Authentification LDAP",
  allowed: true,
  risk: "high"
}]->(b);
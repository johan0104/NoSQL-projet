// =======================================================
// PROJET NoSQL / Neo4j
// Cartographie SI et analyse des chemins d'attaque
// Entreprise fictive : MedSecure
// Scénario : poste compromis = PC-NINA
// =======================================================


// =======================================================
// 0. NETTOYAGE DE LA BASE
// =======================================================

MATCH (n)
DETACH DELETE n;


// =======================================================
// 1. CONTRAINTES D'UNICITÉ
// =======================================================

CREATE CONSTRAINT user_name_unique IF NOT EXISTS
FOR (u:User)
REQUIRE u.name IS UNIQUE;

CREATE CONSTRAINT machine_name_unique IF NOT EXISTS
FOR (m:Machine)
REQUIRE m.name IS UNIQUE;

CREATE CONSTRAINT group_name_unique IF NOT EXISTS
FOR (g:Group)
REQUIRE g.name IS UNIQUE;

CREATE CONSTRAINT service_name_unique IF NOT EXISTS
FOR (s:Service)
REQUIRE s.name IS UNIQUE;

CREATE CONSTRAINT vulnerability_cve_unique IF NOT EXISTS
FOR (v:Vulnerability)
REQUIRE v.cve IS UNIQUE;

CREATE CONSTRAINT resource_name_unique IF NOT EXISTS
FOR (r:Resource)
REQUIRE r.name IS UNIQUE;

CREATE CONSTRAINT zone_name_unique IF NOT EXISTS
FOR (z:Zone)
REQUIRE z.name IS UNIQUE;

CREATE CONSTRAINT control_name_unique IF NOT EXISTS
FOR (c:Control)
REQUIRE c.name IS UNIQUE;


// =======================================================
// 2. UTILISATEURS
// =======================================================

CREATE
(:User {
  name: "nina",
  full_name: "Nina Martin",
  role: "Assistante médicale",
  department: "MEDICAL",
  privilege: "standard",
  mfa_enabled: false,
  risk_level: "medium"
}),
(:User {
  name: "paul",
  full_name: "Paul Bernard",
  role: "Développeur applicatif",
  department: "DEV",
  privilege: "standard",
  mfa_enabled: true,
  risk_level: "low"
}),
(:User {
  name: "sarah",
  full_name: "Sarah Lopez",
  role: "Technicienne support",
  department: "IT",
  privilege: "power_user",
  mfa_enabled: true,
  risk_level: "medium"
}),
(:User {
  name: "karim",
  full_name: "Karim Haddad",
  role: "Administrateur système",
  department: "IT",
  privilege: "admin",
  mfa_enabled: true,
  risk_level: "high"
}),
(:User {
  name: "emma",
  full_name: "Emma Leroy",
  role: "Responsable sécurité",
  department: "SECURITY",
  privilege: "security_admin",
  mfa_enabled: true,
  risk_level: "high"
}),
(:User {
  name: "leo",
  full_name: "Léo Garnier",
  role: "Stagiaire",
  department: "MEDICAL",
  privilege: "limited",
  mfa_enabled: false,
  risk_level: "medium"
}),
(:User {
  name: "svc_app",
  full_name: "Compte service application",
  role: "Compte de service",
  department: "DEV",
  privilege: "service_account",
  mfa_enabled: false,
  risk_level: "high"
}),
(:User {
  name: "svc_backup",
  full_name: "Compte service sauvegarde",
  role: "Compte de service",
  department: "IT",
  privilege: "service_account",
  mfa_enabled: false,
  risk_level: "critical"
});


// =======================================================
// 3. GROUPES
// =======================================================

CREATE
(:Group {
  name: "MEDICAL",
  description: "Personnel médical"
}),
(:Group {
  name: "DEV",
  description: "Développeurs applicatifs"
}),
(:Group {
  name: "IT_SUPPORT",
  description: "Support informatique"
}),
(:Group {
  name: "SYS_ADMINS",
  description: "Administrateurs système"
}),
(:Group {
  name: "SECURITY_TEAM",
  description: "Équipe cybersécurité"
}),
(:Group {
  name: "BACKUP_OPERATORS",
  description: "Gestionnaires des sauvegardes"
}),
(:Group {
  name: "APP_OPERATORS",
  description: "Gestionnaires des applications internes"
});


// =======================================================
// 4. ZONES RÉSEAU / VLAN
// =======================================================

CREATE
(:Zone {
  name: "VLAN-MEDICAL",
  cidr: "10.10.10.0/24",
  description: "Postes du personnel médical",
  trust_level: "low"
}),
(:Zone {
  name: "VLAN-DEV",
  cidr: "10.10.20.0/24",
  description: "Postes développeurs",
  trust_level: "medium"
}),
(:Zone {
  name: "DMZ",
  cidr: "10.10.30.0/24",
  description: "Serveurs exposés",
  trust_level: "medium"
}),
(:Zone {
  name: "VLAN-SERVERS",
  cidr: "10.10.40.0/24",
  description: "Serveurs internes",
  trust_level: "high"
}),
(:Zone {
  name: "VLAN-DATABASE",
  cidr: "10.10.50.0/24",
  description: "Bases de données",
  trust_level: "critical"
}),
(:Zone {
  name: "VLAN-BACKUP",
  cidr: "10.10.60.0/24",
  description: "Sauvegardes",
  trust_level: "critical"
}),
(:Zone {
  name: "INTERNET",
  cidr: "0.0.0.0/0",
  description: "Réseau externe",
  trust_level: "untrusted"
});


// =======================================================
// 5. MACHINES
// =======================================================

CREATE
(:Machine {
  name: "PC-NINA",
  type: "workstation",
  os: "Windows 10",
  ip: "10.10.10.21",
  vlan: "VLAN-MEDICAL",
  criticality: "low",
  compromised: true,
  patch_level: "outdated",
  exposed_internet: false
}),
(:Machine {
  name: "PC-LEO",
  type: "workstation",
  os: "Windows 10",
  ip: "10.10.10.45",
  vlan: "VLAN-MEDICAL",
  criticality: "low",
  compromised: false,
  patch_level: "outdated",
  exposed_internet: false
}),
(:Machine {
  name: "PC-PAUL",
  type: "developer_workstation",
  os: "Windows 11",
  ip: "10.10.20.30",
  vlan: "VLAN-DEV",
  criticality: "medium",
  compromised: false,
  patch_level: "recent",
  exposed_internet: false
}),
(:Machine {
  name: "SRV-WEB-EXT",
  type: "web_server",
  os: "Ubuntu Server 22.04",
  ip: "10.10.30.10",
  vlan: "DMZ",
  criticality: "medium",
  compromised: false,
  patch_level: "outdated",
  exposed_internet: true
}),
(:Machine {
  name: "SRV-API",
  type: "api_server",
  os: "Debian 12",
  ip: "10.10.40.20",
  vlan: "VLAN-SERVERS",
  criticality: "high",
  compromised: false,
  patch_level: "outdated",
  exposed_internet: false
}),
(:Machine {
  name: "SRV-EHR",
  type: "application_server",
  os: "Debian 12",
  ip: "10.10.40.30",
  vlan: "VLAN-SERVERS",
  criticality: "critical",
  compromised: false,
  patch_level: "recent",
  exposed_internet: false
}),
(:Machine {
  name: "SRV-MONGO",
  type: "database_server",
  os: "Debian 11",
  ip: "10.10.50.10",
  vlan: "VLAN-DATABASE",
  criticality: "critical",
  compromised: false,
  patch_level: "outdated",
  exposed_internet: false
}),
(:Machine {
  name: "DC-MED-01",
  type: "domain_controller",
  os: "Windows Server 2019",
  ip: "10.10.40.5",
  vlan: "VLAN-SERVERS",
  criticality: "critical",
  compromised: false,
  patch_level: "outdated",
  exposed_internet: false
}),
(:Machine {
  name: "NAS-SAFE",
  type: "backup_server",
  os: "TrueNAS",
  ip: "10.10.60.10",
  vlan: "VLAN-BACKUP",
  criticality: "critical",
  compromised: false,
  patch_level: "recent",
  exposed_internet: false
}),
(:Machine {
  name: "FW-EDGE",
  type: "firewall",
  os: "pfSense",
  ip: "10.10.0.1",
  vlan: "NETWORK",
  criticality: "critical",
  compromised: false,
  patch_level: "recent",
  exposed_internet: true
}),
(:Machine {
  name: "SIEM-01",
  type: "security_monitoring",
  os: "Ubuntu Server 22.04",
  ip: "10.10.40.80",
  vlan: "VLAN-SERVERS",
  criticality: "high",
  compromised: false,
  patch_level: "recent",
  exposed_internet: false
});


// =======================================================
// 6. SERVICES
// =======================================================

CREATE
(:Service {
  name: "HTTPS",
  port: 443,
  protocol: "TCP",
  risk: "low",
  description: "Accès web sécurisé"
}),
(:Service {
  name: "HTTP",
  port: 80,
  protocol: "TCP",
  risk: "medium",
  description: "Accès web non chiffré"
}),
(:Service {
  name: "SSH",
  port: 22,
  protocol: "TCP",
  risk: "medium",
  description: "Administration distante Linux"
}),
(:Service {
  name: "RDP",
  port: 3389,
  protocol: "TCP",
  risk: "high",
  description: "Administration distante Windows"
}),
(:Service {
  name: "SMB",
  port: 445,
  protocol: "TCP",
  risk: "high",
  description: "Partage de fichiers Windows"
}),
(:Service {
  name: "LDAP",
  port: 389,
  protocol: "TCP",
  risk: "high",
  description: "Annuaire Active Directory"
}),
(:Service {
  name: "Kerberos",
  port: 88,
  protocol: "TCP/UDP",
  risk: "high",
  description: "Authentification domaine"
}),
(:Service {
  name: "MongoDB",
  port: 27017,
  protocol: "TCP",
  risk: "high",
  description: "Base documentaire NoSQL"
}),
(:Service {
  name: "Backup-Agent",
  port: 9102,
  protocol: "TCP",
  risk: "medium",
  description: "Agent de sauvegarde"
}),
(:Service {
  name: "Syslog",
  port: 514,
  protocol: "UDP",
  risk: "low",
  description: "Collecte des logs"
});


// =======================================================
// 7. VULNÉRABILITÉS
// =======================================================

CREATE
(:Vulnerability {
  cve: "CVE-2021-44228",
  name: "Log4Shell",
  severity: "critical",
  score: 10.0,
  category: "RCE",
  description: "Exécution de code à distance via Log4j"
}),
(:Vulnerability {
  cve: "CVE-2020-1472",
  name: "Zerologon",
  severity: "critical",
  score: 10.0,
  category: "Privilege Escalation",
  description: "Élévation de privilèges sur contrôleur de domaine"
}),
(:Vulnerability {
  cve: "CVE-2019-0708",
  name: "BlueKeep",
  severity: "critical",
  score: 9.8,
  category: "RCE",
  description: "Exécution de code à distance via RDP"
}),
(:Vulnerability {
  cve: "CVE-2022-22965",
  name: "Spring4Shell",
  severity: "critical",
  score: 9.8,
  category: "RCE",
  description: "Faille critique sur application Spring"
}),
(:Vulnerability {
  cve: "CVE-2023-0001",
  name: "SMB Misconfiguration",
  severity: "high",
  score: 7.5,
  category: "Misconfiguration",
  description: "Partage SMB trop permissif"
}),
(:Vulnerability {
  cve: "CVE-2024-0002",
  name: "Weak Password Policy",
  severity: "high",
  score: 8.1,
  category: "Identity",
  description: "Politique de mot de passe faible"
}),
(:Vulnerability {
  cve: "CVE-2024-0003",
  name: "MongoDB Without Authentication",
  severity: "critical",
  score: 9.1,
  category: "Misconfiguration",
  description: "Base MongoDB accessible sans authentification forte"
}),
(:Vulnerability {
  cve: "CVE-2024-0004",
  name: "Exposed Admin Panel",
  severity: "high",
  score: 8.8,
  category: "Exposure",
  description: "Interface d'administration exposée"
});


// =======================================================
// 8. RESSOURCES SENSIBLES
// =======================================================

CREATE
(:Resource {
  name: "Dossiers patients",
  sensitivity: "critical",
  category: "health_data",
  description: "Données médicales confidentielles"
}),
(:Resource {
  name: "Identités patients",
  sensitivity: "high",
  category: "personal_data",
  description: "Identité, téléphone, adresse et informations administratives"
}),
(:Resource {
  name: "Active Directory",
  sensitivity: "critical",
  category: "identity",
  description: "Annuaire central et authentification"
}),
(:Resource {
  name: "Sauvegardes médicales",
  sensitivity: "critical",
  category: "backup",
  description: "Sauvegardes des données critiques"
}),
(:Resource {
  name: "Secrets API",
  sensitivity: "critical",
  category: "secret",
  description: "Tokens, clés API et identifiants applicatifs"
}),
(:Resource {
  name: "Logs sécurité",
  sensitivity: "high",
  category: "monitoring",
  description: "Journaux d'événements de sécurité"
});


// =======================================================
// 9. CONTRÔLES DE SÉCURITÉ
// =======================================================

CREATE
(:Control {
  name: "MFA",
  type: "identity",
  efficiency: "high",
  description: "Authentification multifacteur"
}),
(:Control {
  name: "EDR",
  type: "endpoint",
  efficiency: "medium",
  description: "Détection et réponse endpoint"
}),
(:Control {
  name: "Firewall segmentation",
  type: "network",
  efficiency: "high",
  description: "Filtrage inter-VLAN"
}),
(:Control {
  name: "Patch management",
  type: "system",
  efficiency: "high",
  description: "Gestion des correctifs"
}),
(:Control {
  name: "SIEM monitoring",
  type: "monitoring",
  efficiency: "medium",
  description: "Supervision et corrélation des logs"
});


// =======================================================
// 10. RELATIONS USER -> MACHINE
// =======================================================

MATCH (u:User {name: "nina"}), (m:Machine {name: "PC-NINA"})
CREATE (u)-[:USES]->(m);

MATCH (u:User {name: "leo"}), (m:Machine {name: "PC-LEO"})
CREATE (u)-[:USES]->(m);

MATCH (u:User {name: "paul"}), (m:Machine {name: "PC-PAUL"})
CREATE (u)-[:USES]->(m);

MATCH (u:User {name: "sarah"}), (m:Machine {name: "SIEM-01"})
CREATE (u)-[:USES]->(m);

MATCH (u:User {name: "karim"}), (m:Machine {name: "DC-MED-01"})
CREATE (u)-[:USES]->(m);

MATCH (u:User {name: "emma"}), (m:Machine {name: "SIEM-01"})
CREATE (u)-[:USES]->(m);


// =======================================================
// 11. RELATIONS USER -> GROUP
// =======================================================

MATCH (u:User {name: "nina"}), (g:Group {name: "MEDICAL"})
CREATE (u)-[:MEMBER_OF]->(g);

MATCH (u:User {name: "leo"}), (g:Group {name: "MEDICAL"})
CREATE (u)-[:MEMBER_OF]->(g);

MATCH (u:User {name: "paul"}), (g:Group {name: "DEV"})
CREATE (u)-[:MEMBER_OF]->(g);

MATCH (u:User {name: "sarah"}), (g:Group {name: "IT_SUPPORT"})
CREATE (u)-[:MEMBER_OF]->(g);

MATCH (u:User {name: "karim"}), (g:Group {name: "SYS_ADMINS"})
CREATE (u)-[:MEMBER_OF]->(g);

MATCH (u:User {name: "emma"}), (g:Group {name: "SECURITY_TEAM"})
CREATE (u)-[:MEMBER_OF]->(g);

MATCH (u:User {name: "svc_app"}), (g:Group {name: "APP_OPERATORS"})
CREATE (u)-[:MEMBER_OF]->(g);

MATCH (u:User {name: "svc_backup"}), (g:Group {name: "BACKUP_OPERATORS"})
CREATE (u)-[:MEMBER_OF]->(g);


// =======================================================
// 12. RELATIONS ADMINISTRATION
// =======================================================

MATCH (u:User {name: "karim"}), (m:Machine {name: "DC-MED-01"})
CREATE (u)-[:ADMIN_OF {method: "RDP", privilege: "domain_admin"}]->(m);

MATCH (u:User {name: "karim"}), (m:Machine {name: "SRV-MONGO"})
CREATE (u)-[:ADMIN_OF {method: "SSH", privilege: "root"}]->(m);

MATCH (u:User {name: "karim"}), (m:Machine {name: "NAS-SAFE"})
CREATE (u)-[:ADMIN_OF {method: "SSH", privilege: "admin"}]->(m);

MATCH (u:User {name: "emma"}), (m:Machine {name: "FW-EDGE"})
CREATE (u)-[:ADMIN_OF {method: "HTTPS", privilege: "security_admin"}]->(m);

MATCH (u:User {name: "svc_app"}), (m:Machine {name: "SRV-API"})
CREATE (u)-[:ADMIN_OF {method: "token", privilege: "app_admin"}]->(m);

MATCH (u:User {name: "svc_backup"}), (m:Machine {name: "NAS-SAFE"})
CREATE (u)-[:ADMIN_OF {method: "backup-agent", privilege: "backup_admin"}]->(m);


// =======================================================
// 13. RELATIONS MACHINE -> ZONE
// =======================================================

MATCH (m:Machine {name: "PC-NINA"}), (z:Zone {name: "VLAN-MEDICAL"})
CREATE (m)-[:LOCATED_IN]->(z);

MATCH (m:Machine {name: "PC-LEO"}), (z:Zone {name: "VLAN-MEDICAL"})
CREATE (m)-[:LOCATED_IN]->(z);

MATCH (m:Machine {name: "PC-PAUL"}), (z:Zone {name: "VLAN-DEV"})
CREATE (m)-[:LOCATED_IN]->(z);

MATCH (m:Machine {name: "SRV-WEB-EXT"}), (z:Zone {name: "DMZ"})
CREATE (m)-[:LOCATED_IN]->(z);

MATCH (m:Machine {name: "SRV-API"}), (z:Zone {name: "VLAN-SERVERS"})
CREATE (m)-[:LOCATED_IN]->(z);

MATCH (m:Machine {name: "SRV-EHR"}), (z:Zone {name: "VLAN-SERVERS"})
CREATE (m)-[:LOCATED_IN]->(z);

MATCH (m:Machine {name: "SRV-MONGO"}), (z:Zone {name: "VLAN-DATABASE"})
CREATE (m)-[:LOCATED_IN]->(z);

MATCH (m:Machine {name: "DC-MED-01"}), (z:Zone {name: "VLAN-SERVERS"})
CREATE (m)-[:LOCATED_IN]->(z);

MATCH (m:Machine {name: "NAS-SAFE"}), (z:Zone {name: "VLAN-BACKUP"})
CREATE (m)-[:LOCATED_IN]->(z);

MATCH (m:Machine {name: "FW-EDGE"}), (z:Zone {name: "INTERNET"})
CREATE (m)-[:BORDERS]->(z);

MATCH (m:Machine {name: "SIEM-01"}), (z:Zone {name: "VLAN-SERVERS"})
CREATE (m)-[:LOCATED_IN]->(z);


// =======================================================
// 14. ACCÈS DES GROUPES AUX MACHINES
// =======================================================

MATCH (g:Group {name: "MEDICAL"}), (m:Machine {name: "SRV-EHR"})
CREATE (g)-[:HAS_ACCESS_TO {access_level: "user", reason: "Consultation dossiers patients"}]->(m);

MATCH (g:Group {name: "MEDICAL"}), (m:Machine {name: "SRV-WEB-EXT"})
CREATE (g)-[:HAS_ACCESS_TO {access_level: "user", reason: "Portail médical"}]->(m);

MATCH (g:Group {name: "DEV"}), (m:Machine {name: "SRV-API"})
CREATE (g)-[:HAS_ACCESS_TO {access_level: "developer", reason: "Déploiement application"}]->(m);

MATCH (g:Group {name: "IT_SUPPORT"}), (m:Machine {name: "PC-NINA"})
CREATE (g)-[:HAS_ACCESS_TO {access_level: "support", reason: "Assistance utilisateur"}]->(m);

MATCH (g:Group {name: "SYS_ADMINS"}), (m:Machine {name: "DC-MED-01"})
CREATE (g)-[:HAS_ACCESS_TO {access_level: "domain_admin", reason: "Administration domaine"}]->(m);

MATCH (g:Group {name: "SYS_ADMINS"}), (m:Machine {name: "SRV-MONGO"})
CREATE (g)-[:HAS_ACCESS_TO {access_level: "root", reason: "Administration base"}]->(m);

MATCH (g:Group {name: "SECURITY_TEAM"}), (m:Machine {name: "SIEM-01"})
CREATE (g)-[:HAS_ACCESS_TO {access_level: "security_admin", reason: "Supervision sécurité"}]->(m);

MATCH (g:Group {name: "BACKUP_OPERATORS"}), (m:Machine {name: "NAS-SAFE"})
CREATE (g)-[:HAS_ACCESS_TO {access_level: "backup_admin", reason: "Gestion sauvegardes"}]->(m);

MATCH (g:Group {name: "APP_OPERATORS"}), (m:Machine {name: "SRV-API"})
CREATE (g)-[:HAS_ACCESS_TO {access_level: "app_admin", reason: "Gestion application"}]->(m);


// =======================================================
// 15. CONNEXIONS RÉSEAU ENTRE MACHINES
// Ici, on modélise les chemins d'attaque possibles.
// =======================================================

MATCH (a:Machine {name: "FW-EDGE"}), (b:Machine {name: "SRV-WEB-EXT"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "HTTPS",
  port: 443,
  rule: "NAT public vers DMZ",
  allowed: true,
  risk: "medium"
}]->(b);

MATCH (a:Machine {name: "PC-NINA"}), (b:Machine {name: "SRV-WEB-EXT"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "HTTPS",
  port: 443,
  rule: "Accès portail web",
  allowed: true,
  risk: "low"
}]->(b);

MATCH (a:Machine {name: "PC-NINA"}), (b:Machine {name: "SRV-EHR"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "HTTPS",
  port: 443,
  rule: "Accès application médicale",
  allowed: true,
  risk: "medium"
}]->(b);

MATCH (a:Machine {name: "PC-LEO"}), (b:Machine {name: "SRV-EHR"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "HTTPS",
  port: 443,
  rule: "Accès stagiaire trop large",
  allowed: true,
  risk: "high"
}]->(b);

MATCH (a:Machine {name: "PC-PAUL"}), (b:Machine {name: "SRV-API"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "SSH",
  port: 22,
  rule: "Accès développeur",
  allowed: true,
  risk: "medium"
}]->(b);

MATCH (a:Machine {name: "SRV-WEB-EXT"}), (b:Machine {name: "SRV-API"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "HTTP",
  port: 80,
  rule: "Flux web vers API",
  allowed: true,
  risk: "high"
}]->(b);

MATCH (a:Machine {name: "SRV-API"}), (b:Machine {name: "SRV-EHR"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "HTTPS",
  port: 443,
  rule: "API vers application médicale",
  allowed: true,
  risk: "medium"
}]->(b);

MATCH (a:Machine {name: "SRV-EHR"}), (b:Machine {name: "SRV-MONGO"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "MongoDB",
  port: 27017,
  rule: "Application vers base NoSQL",
  allowed: true,
  risk: "high"
}]->(b);

MATCH (a:Machine {name: "SRV-MONGO"}), (b:Machine {name: "DC-MED-01"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "LDAP",
  port: 389,
  rule: "Authentification LDAP",
  allowed: true,
  risk: "high"
}]->(b);

MATCH (a:Machine {name: "DC-MED-01"}), (b:Machine {name: "NAS-SAFE"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "Backup-Agent",
  port: 9102,
  rule: "Sauvegarde contrôleur domaine",
  allowed: true,
  risk: "medium"
}]->(b);

MATCH (a:Machine {name: "SRV-MONGO"}), (b:Machine {name: "NAS-SAFE"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "SMB",
  port: 445,
  rule: "Sauvegarde base médicale",
  allowed: true,
  risk: "high"
}]->(b);

MATCH (a:Machine {name: "SIEM-01"}), (b:Machine {name: "SRV-API"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "Syslog",
  port: 514,
  rule: "Collecte logs",
  allowed: true,
  risk: "low"
}]->(b);

MATCH (a:Machine {name: "SIEM-01"}), (b:Machine {name: "DC-MED-01"})
CREATE (a)-[:CONNECTED_TO {
  protocol: "Syslog",
  port: 514,
  rule: "Collecte logs AD",
  allowed: true,
  risk: "low"
}]->(b);


// =======================================================
// 16. SERVICES EXPOSÉS PAR LES MACHINES
// =======================================================

MATCH (m:Machine {name: "PC-NINA"}), (s:Service {name: "SMB"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "PC-LEO"}), (s:Service {name: "SMB"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "PC-PAUL"}), (s:Service {name: "RDP"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "SRV-WEB-EXT"}), (s:Service {name: "HTTP"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "SRV-WEB-EXT"}), (s:Service {name: "HTTPS"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "SRV-WEB-EXT"}), (s:Service {name: "SSH"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "SRV-API"}), (s:Service {name: "HTTP"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "SRV-API"}), (s:Service {name: "SSH"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "SRV-EHR"}), (s:Service {name: "HTTPS"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "SRV-MONGO"}), (s:Service {name: "MongoDB"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "DC-MED-01"}), (s:Service {name: "LDAP"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "DC-MED-01"}), (s:Service {name: "Kerberos"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "DC-MED-01"}), (s:Service {name: "SMB"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "NAS-SAFE"}), (s:Service {name: "SMB"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "NAS-SAFE"}), (s:Service {name: "Backup-Agent"})
CREATE (m)-[:EXPOSES]->(s);

MATCH (m:Machine {name: "SIEM-01"}), (s:Service {name: "Syslog"})
CREATE (m)-[:EXPOSES]->(s);


// =======================================================
// 17. VULNÉRABILITÉS PAR MACHINE
// =======================================================

MATCH (m:Machine {name: "PC-NINA"}), (v:Vulnerability {cve: "CVE-2024-0002"})
CREATE (m)-[:HAS_VULNERABILITY {
  status: "open",
  exploitability: "medium"
}]->(v);

MATCH (m:Machine {name: "PC-NINA"}), (v:Vulnerability {cve: "CVE-2023-0001"})
CREATE (m)-[:HAS_VULNERABILITY {
  status: "open",
  exploitability: "high"
}]->(v);

MATCH (m:Machine {name: "PC-LEO"}), (v:Vulnerability {cve: "CVE-2024-0002"})
CREATE (m)-[:HAS_VULNERABILITY {
  status: "open",
  exploitability: "medium"
}]->(v);

MATCH (m:Machine {name: "PC-PAUL"}), (v:Vulnerability {cve: "CVE-2019-0708"})
CREATE (m)-[:HAS_VULNERABILITY {
  status: "open",
  exploitability: "high"
}]->(v);

MATCH (m:Machine {name: "SRV-WEB-EXT"}), (v:Vulnerability {cve: "CVE-2021-44228"})
CREATE (m)-[:HAS_VULNERABILITY {
  status: "open",
  exploitability: "high"
}]->(v);

MATCH (m:Machine {name: "SRV-WEB-EXT"}), (v:Vulnerability {cve: "CVE-2024-0004"})
CREATE (m)-[:HAS_VULNERABILITY {
  status: "open",
  exploitability: "medium"
}]->(v);

MATCH (m:Machine {name: "SRV-API"}), (v:Vulnerability {cve: "CVE-2022-22965"})
CREATE (m)-[:HAS_VULNERABILITY {
  status: "open",
  exploitability: "high"
}]->(v);

MATCH (m:Machine {name: "SRV-MONGO"}), (v:Vulnerability {cve: "CVE-2024-0003"})
CREATE (m)-[:HAS_VULNERABILITY {
  status: "open",
  exploitability: "high"
}]->(v);

MATCH (m:Machine {name: "SRV-MONGO"}), (v:Vulnerability {cve: "CVE-2023-0001"})
CREATE (m)-[:HAS_VULNERABILITY {
  status: "open",
  exploitability: "medium"
}]->(v);

MATCH (m:Machine {name: "DC-MED-01"}), (v:Vulnerability {cve: "CVE-2020-1472"})
CREATE (m)-[:HAS_VULNERABILITY {
  status: "open",
  exploitability: "high"
}]->(v);


// =======================================================
// 18. HÉBERGEMENT DES RESSOURCES SENSIBLES
// =======================================================

MATCH (m:Machine {name: "SRV-MONGO"}), (r:Resource {name: "Dossiers patients"})
CREATE (m)-[:HOSTS]->(r);

MATCH (m:Machine {name: "SRV-MONGO"}), (r:Resource {name: "Identités patients"})
CREATE (m)-[:HOSTS]->(r);

MATCH (m:Machine {name: "DC-MED-01"}), (r:Resource {name: "Active Directory"})
CREATE (m)-[:HOSTS]->(r);

MATCH (m:Machine {name: "NAS-SAFE"}), (r:Resource {name: "Sauvegardes médicales"})
CREATE (m)-[:HOSTS]->(r);

MATCH (m:Machine {name: "SRV-API"}), (r:Resource {name: "Secrets API"})
CREATE (m)-[:HOSTS]->(r);

MATCH (m:Machine {name: "SIEM-01"}), (r:Resource {name: "Logs sécurité"})
CREATE (m)-[:HOSTS]->(r);


// =======================================================
// 19. CONTRÔLES DE SÉCURITÉ APPLIQUÉS
// =======================================================

MATCH (m:Machine {name: "PC-NINA"}), (c:Control {name: "EDR"})
CREATE (m)-[:PROTECTED_BY {status: "partial"}]->(c);

MATCH (m:Machine {name: "PC-PAUL"}), (c:Control {name: "EDR"})
CREATE (m)-[:PROTECTED_BY {status: "active"}]->(c);

MATCH (m:Machine {name: "SRV-API"}), (c:Control {name: "Patch management"})
CREATE (m)-[:PROTECTED_BY {status: "late"}]->(c);

MATCH (m:Machine {name: "SRV-MONGO"}), (c:Control {name: "Patch management"})
CREATE (m)-[:PROTECTED_BY {status: "late"}]->(c);

MATCH (m:Machine {name: "FW-EDGE"}), (c:Control {name: "Firewall segmentation"})
CREATE (m)-[:PROTECTED_BY {status: "active"}]->(c);

MATCH (m:Machine {name: "SIEM-01"}), (c:Control {name: "SIEM monitoring"})
CREATE (m)-[:PROTECTED_BY {status: "active"}]->(c);

MATCH (u:User {name: "karim"}), (c:Control {name: "MFA"})
CREATE (u)-[:PROTECTED_BY {status: "active"}]->(c);

MATCH (u:User {name: "emma"}), (c:Control {name: "MFA"})
CREATE (u)-[:PROTECTED_BY {status: "active"}]->(c);

MATCH (u:User {name: "nina"}), (c:Control {name: "MFA"})
CREATE (u)-[:PROTECTED_BY {status: "missing"}]->(c);


// =======================================================
// 20. MARQUAGE DU SCÉNARIO DE COMPROMISSION
// =======================================================

MATCH (m:Machine {name: "PC-NINA"})
SET m.attack_entrypoint = true,
    m.attack_vector = "Phishing avec pièce jointe malveillante",
    m.incident = "poste utilisateur compromis";
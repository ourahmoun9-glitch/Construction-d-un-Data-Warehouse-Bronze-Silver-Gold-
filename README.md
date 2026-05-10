# 🏗️ Data Warehouse — Architecture Bronze / Silver / Gold

## 📋 Contexte du projet

Dans un contexte de Data Engineering moderne, ce projet vise à **centraliser et structurer** des données provenant de systèmes opérationnels (ERP, CRM, fichiers CSV, etc.) afin de les rendre **exploitables** pour l'analyse et la prise de décision.

Le projet consiste à concevoir un **Data Warehouse complet** basé sur une architecture en couches, permettant :

- L'ingestion de données brutes depuis des fichiers CSV (sources financières et opérationnelles)
- La structuration des données dans une couche Bronze
- Le nettoyage et la standardisation des données dans une couche Silver
- La modélisation des données dans une couche Gold basée sur un modèle en étoile (Star Schema)
- La préparation des données pour l'analyse et le reporting

---

## 🎯 Objectifs pédagogiques

- Construire une architecture Data Warehouse (Bronze / Silver / Gold)
- Charger des données CSV dans une base SQL
- Nettoyer et standardiser des données
- Transformer des données brutes en données analytiques
- Créer des vues SQL pour l'analyse finale
- Vérifier la qualité des données à chaque étape

---

## 🏛️ Architecture du projet

```
CSV (source) → BRONZE → SILVER → GOLD
```

Chaque couche a un rôle précis :

| Couche | Rôle |
|--------|------|
| 🟤 **Bronze** | Données brutes sans transformation (copie fidèle des fichiers source) |
| ⚪ **Silver** | Nettoyage et standardisation technique |
| 🟡 **Gold** | Modélisation pour analyse et reporting |

---

## 🔄 Étapes du projet

### 1. 🟤 Bronze Layer — Ingestion des données

**Objectif : Charger les fichiers CSV sans aucune transformation.**

- Créer la base de données `DataWarehouse`
- Créer les schémas : `bronze`, `silver` et `gold`
- Créer les tables Bronze : `account`, `store`, `gl_transaction`, `storemaster`, `account_mapping`
- Charger les données CSV avec `BULK INSERT`

---

### 2. ⚪ Silver Layer — Nettoyage des données

**Objectif : Nettoyer, standardiser et structurer les données pour analyse.**

- **Nettoyage technique** : `TRIM` des espaces, `UPPER` des codes, `CAST` des types de données, gestion des valeurs nulles, suppression des doublons
- **Standardisation** : correction des incohérences (ex : `"P L"` → `"P&L"`), nettoyage des champs texte, harmonisation des formats
- **Données métiers** : normalisation des clés métiers, structuration cohérente des tables

---

### 3. 🟡 Gold Layer — Modèle analytique

**Objectif : Construire un modèle de données prêt pour l'analyse.**

Modèle en étoile **(Star Schema)** :

- **Dimensions** : `dimstore`, `dimaccount`
- **Table de faits** : `fact_gl` (transactions enrichies)

Jointures réalisées :
- Transactions ↔ Comptes
- Transactions ↔ Magasins

---

### 4. ✅ Data Quality Checks

À chaque étape, vérifier :

- Absence de doublons
- Cohérence des clés
- Intégrité des relations entre tables
- Aucune valeur critique manquante
- Concordance entre les couches Bronze / Silver / Gold

Exemples de contrôles :
- `COUNT` entre tables Bronze et Silver
- Vérification des clés étrangères
- Détection des doublons

---

### 5. 📊 Power BI Layer — Visualisation & Reporting

**Objectif : Transformer les données du modèle Gold en tableaux de bord interactifs pour l'analyse métier.**

- **Connexion** de Power BI à la base `DataWarehouse`, couche Gold
- **Modélisation** en étoile (dimensions + table de faits)
- **Tableaux de bord** :
  - Vue globale des performances financières (P&L)
  - Analyse des revenus et des coûts
  - Suivi des tendances dans le temps
  - Analyse par magasins et catégories

---

## 🛠️ Outils & Technologies

| Outil | Usage |
|-------|-------|
| **SQL Server Management Studio (SSMS)** | Gestion de la base de données |
| **SQL / T-SQL** | Scripts d'ingestion, transformation et modélisation |
| **Power BI** | Visualisation et reporting |
| **GitHub** | Versioning des scripts SQL |

---

## 📁 Structure du projet

```
📦 data-warehouse-project/
├── 📂 bronze/
│   ├── create_tables.sql
│   └── bulk_insert.sql
├── 📂 silver/
│   ├── clean_accounts.sql
│   ├── clean_stores.sql
│   └── clean_transactions.sql
├── 📂 gold/
│   ├── dim_store.sql
│   ├── dim_account.sql
│   └── fact_gl.sql
├── 📂 quality_checks/
│   └── data_quality.sql
├── 📂 data/
│   └── (fichiers CSV sources)
└── README.md
```

---

## 📦 Livrables

- 📁 **Repo GitHub** : scripts SQL organisés par couche
- 📄 **README** : documentation du projet
- 🗄️ **Data Warehouse** : base fonctionnelle sous SQL Server
- 📊 **Analyse** : requêtes SQL et tableaux de bord Power BI
- 🎞️ **Présentation** : support PowerPoint / Canva

---

## ✅ Critères de performance

- ✔️ Qualité de la conception de l'architecture Data Warehouse (Bronze / Silver / Gold)
- ✔️ Bonne séparation des responsabilités entre les couches (Brut / Nettoyage / Modélisation)
- ✔️ Maîtrise des scripts SQL et des opérations d'ingestion (`BULK INSERT`)
- ✔️ Qualité du nettoyage et de la standardisation des données en Silver
- ✔️ Gestion correcte des types de données et des clés métiers
- ✔️ Pertinence du modèle analytique en Gold (modèle en étoile / Star Schema)
- ✔️ Qualité des jointures entre tables de faits et dimensions
- ✔️ Cohérence globale du pipeline de bout en bout (de Bronze jusqu'à Gold)

---

## 📅 Modalités

| | |
|--|--|
| **Travail** | Individuel |
| **Durée** | 5 jours |
| **Période** | Du 04/05/2026 au 08/05/2026 avant 17h00 |

---

## 📝 Évaluation

- **Présentation** (10–15 min) : architecture du Data Warehouse, flux ETL, transformations Silver et modèle Gold
- **Démonstration** (10–15 min) : chargement Bronze, transformations Silver, vues Gold et requêtes SQL
- **Questions** (5–10 min) : architecture ETL, rôle des couches, dimensions/faits et contrôles qualité

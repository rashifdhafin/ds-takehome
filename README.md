# ds-takehome
Repository for Data Scientist take home test provided by Talentport

# Data Scientist Take-Home Project

This project consists of three subtests:
1. SQL-based e-commerce transaction analysis
2. Python-based credit risk modeling (under development)
3. R-based model validation (not yet configured)

## 🔧 Environment Setup (Python Only)

Ensure you have Python 3.11+ installed.

### 1. Clone the repository
```bash
git clone https://github.com/your-username/ds-takehome.git
cd ds-takehome
```

### 2. Create and activate virtual environment
```bash
python -m venv .venv
# Activate:
# Windows
.venv\Scripts\activate
# macOS/Linux
source .venv/bin/activate
```

### 3. Install required Python packages
```bash
pip install -r requirements.txt
```

**If you haven't created it yet**, freeze your installed packages into `requirements.txt`:
```bash
pip freeze > requirements.txt
```

### 4. Start the Jupyter Notebook
```bash
jupyter notebook
```

Open `notebooks/your_notebook_file.ipynb` to view and run the Python analysis.

## 📂 Project Structure

```
ds-takehome/
│
├── data/                        # Contains the raw CSV files
│   ├── e_commerce_transactions.csv
│   └── credit_scoring.csv
│
├── notebooks/                  # Python notebooks for modeling
│   └── B_modeling.ipynb
│   └── sql_analysis.ipynb
│
├── analysis.sql                # SQL script for subtest 1
├── README.md                   # You're here
├── requirements.txt            # Python dependencies
└──.gitignore 
```

## 📌 Notes

- SQL analysis is written in `analysis.sql` and can be executed using DuckDB or any SQL engine that supports reading CSV files.
- Python code uses DuckDB to query directly from the CSV files, and Scikit-learn for modeling.
- R environment setup and validation steps will be added later.

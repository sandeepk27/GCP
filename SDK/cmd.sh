gcloud config list -- list all configurations
gcloud config set project PROJECT_ID  -- set the default project
gcloud config set account ACCOUNT  -- set the default account
gcloud config set compute/region REGION  -- set the default region
gcloud config set compute/zone ZONE  -- set the default zone
gcloud compute instances list -- list all instances


# Authenticate using a service account key file
gcloud auth activate-service-account SERVICE_ACCOUNT_EMAIL --key-file=PATH_TO_KEY_FILE.json


# Run a SQL query directly using the BigQuery command-line tool
bq legacy no-sql=false 
"SELECT
    artist_name,
    COUNT(*) AS track_count
 FROM
    `PROJECT_ID.DATASET.TABLE`
 GROUP BY
    artist_name
 ORDER BY
    track_count DESC
 LIMIT 10"

# Create a new dataset
gcloud bigquery datasets create DATASET_NAME --location=LOCATION

# Load data from a CSV file into a BigQuery table
gcloud bigquery tables create TABLE_NAME --dataset=DATASET_NAME --schema=SCHEMA_FILE.json

gcloud bigquery tables update TABLE_NAME --source=gs://BUCKET_NAME/FILE_NAME.csv

# Create a new bucket
gcloud storage buckets create BUCKET_NAME --location=LOCATION

# List all buckets
gcloud storage buckets list

# Upload a file to a bucket
gcloud storage cp LOCAL_FILE_PATH gs://BUCKET_NAME/

# Create a Cloud Scheduler job to run a BigQuery query
gcloud scheduler jobs create http JOB_NAME \
    --schedule="0 12 * * *" \
    --uri="https://bigquery.googleapis.com/bigquery/v2/projects/PROJECT_ID/queries" \
    --http-method=POST \
    --headers="Authorization: Bearer $(gcloud auth print-access-token)" \
    --message-body='{
        "query": "SELECT * FROM `PROJECT_ID.DATASET.TABLE` LIMIT 1000",
        "useLegacySql": false
    }'

# List BigQuery jobs
gcloud bigquery jobs list

# Get details of a specific job
gcloud bigquery jobs describe JOB_ID

# Run a Dataflow job using a template
gcloud dataflow jobs run JOB_NAME \
    --gcs-location=gs://DATAFLOW_TEMPLATE_PATH \
    --parameters inputFile=gs://BUCKET_NAME/INPUT_FILE,outputFile=gs://BUCKET_NAME/OUTPUT_FILE
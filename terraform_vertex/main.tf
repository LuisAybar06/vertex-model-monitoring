provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_bigquery_table" "table_predictions" {
  table_id   = "predictions"
  dataset_id = "laybarm"
  project    = var.project_id

  schema = jsonencode([
    {
      "name": "prediction",
      "mode": "",
      "type": "INTEGER",
      "description": "",
      "fields": []
    },
    {
      "name": "creation_user",
      "mode": "",
      "type": "STRING",
      "description": "",
      "fields": []
    },
    {
      "name": "process_date",
      "mode": "",
      "type": "DATE",
      "description": "",
      "fields": []
    },
    {
      "name": "load_date",
      "mode": "",
      "type": "TIMESTAMP",
      "description": "",
      "fields": []
    }
  ])
}

resource "google_bigquery_table_iam_binding" "table_predictions_editor" {
  table_id   = google_bigquery_table.table_predictions.table_id
  dataset_id = google_bigquery_table.table_predictions.dataset_id
  project    = google_bigquery_table.table_predictions.project

  role    = "roles/bigquery.dataEditor"
  members = [
    "serviceAccount:github-actions@trim-odyssey-390415.iam.gserviceaccount.com"
  ]
}

resource "google_bigquery_table_iam_binding" "table_predictions_viewer" {
  table_id   = google_bigquery_table.table_predictions.table_id
  dataset_id = google_bigquery_table.table_predictions.dataset_id
  project    = google_bigquery_table.table_predictions.project

  role    = "roles/bigquery.dataViewer"
  members = [
    "serviceAccount:github-actions@trim-odyssey-390415.iam.gserviceaccount.com"
  ]
}

provider "google" {
    project = var.project_id
    region  = var.region
  }
  
  resource "google_bigquery_dataset" "dataset" {
    dataset_id = "laybarm"
    project    = var.project_id
    location   = var.region
  }
  
  resource "google_bigquery_table" "table1" {
    table_id   = "my_table1"
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    project    = var.project_id
  
    schema = jsonencode([
      {
        name = "id"
        type = "STRING"
        mode = "REQUIRED"
      },
      {
        name = "name"
        type = "STRING"
        mode = "NULLABLE"
      }
    ])
  }
  
  resource "google_bigquery_table" "table2" {
    table_id   = "my_table2"
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    project    = var.project_id
  
    schema = jsonencode([
      {
        name = "id"
        type = "STRING"
        mode = "REQUIRED"
      },
      {
        name = "value"
        type = "FLOAT"
        mode = "NULLABLE"
      }
    ])
  }
  
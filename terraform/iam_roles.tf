resource "google_project_iam_custom_role" "StorageBucketListRole" {
  role_id     = "StorageBucketListRole"
  title       = "Storage Bucket List Role"
  description = "Custom role for listing storage buckets."

  permissions = [
    "storage.buckets.list"
  ]
}
resource "google_project_iam_member" "browser" {
  project = data.google_project.this.project_id
  role    = "roles/browser"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}
resource "google_project_iam_member" "StorageBucketList" {
  project = data.google_project.this.project_id
  role    = google_project_iam_custom_role.StorageBucketListRole.id
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

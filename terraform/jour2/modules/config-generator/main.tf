# modules/config-generator/main.tf
resource "local_file" "config" {
  filename = "${var.output_dir}/${var.filename}"
  content = templatefile("${path.module}/templates/config.tpl", {
    app_name    = var.app_name
    environment = var.environment
    port        = var.port
  })
}

resource "local_file" "readme" {
  filename = "${var.output_dir}/README.md"
  content  = "# ${var.app_name}\n\nEnvironnement : ${var.environment}\nPort : ${var.port}\n"
}

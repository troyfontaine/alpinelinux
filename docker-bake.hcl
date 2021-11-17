group "default" {
    targets = ["container"]
}

target "main" {
    dockerfile  = "${workingdir}/Dockerfile"
}

variable "version" {
    default     = ""
}

variable "arch" {
    default     = ""
}

variable "release" {
    default     = ""
}

variable "workingdir" {
    default     = ""
}

variable "owner" {
    default     = ""
}

variable "repository" {
    default     = ""
}

target "container" {
    inherits    = ["main"]
    tags        = [
        "docker.io/${owner}/${repository}:${arch}-${release}",
        "docker.io/${owner}/${repository}:${arch}-${version}"
    ]
    args        = {
        ALPINE_VERSION = ""
        VCS_REF = ""
        BUILD_DATE = ""
        VERSION = ""
    }
}

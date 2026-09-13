# Terraform AWS Infrastructure

Proyecto de portfolio enfocado en **Infrastructure as Code** con
Terraform: provisiona una arquitectura de 3 capas en AWS (red, cómputo
y base de datos) usando **módulos reutilizables**, en vez de un único
archivo gigante con todo mezclado.

## Arquitectura

```
                    Internet
                        │
                 ┌──────▼──────┐
                 │  Internet    │
                 │  Gateway     │
                 └──────┬──────┘
                        │
        ┌───────────────┴───────────────┐
        │              VPC               │
        │                                │
        │   ┌─────────────────────┐      │
        │   │  Subnet pública      │      │
        │   │  ┌────────────────┐  │      │
        │   │  │  EC2 (app)     │  │      │
        │   │  └───────┬────────┘  │      │
        │   └──────────┼───────────┘      │
        │              │ solo puerto 3306 │
        │              │ (Security Group) │
        │   ┌──────────▼───────────┐      │
        │   │  Subnet privada       │      │
        │   │  ┌─────────────────┐  │      │
        │   │  │  RDS (MySQL)    │  │      │
        │   │  └─────────────────┘  │      │
        │   └───────────────────────┘      │
        └────────────────────────────────┘
```

- **EC2** vive en una subnet **pública** (necesita ser alcanzable).
- **RDS** vive en una subnet **privada** — nunca expuesta a internet.
  Solo acepta conexiones que vengan del Security Group de la EC2.
- Un **NAT Gateway** permite que los recursos privados salgan a
  internet (por ejemplo, para actualizar paquetes) sin que nada de
  afuera pueda iniciar una conexión hacia ellos.

## Por qué está dividido en módulos

En vez de un solo archivo con 15 recursos mezclados, cada capa de la
arquitectura es un módulo independiente (`modules/vpc`,
`modules/ec2`, `modules/rds`), cada uno con sus propias
`variables.tf` (qué recibe) y `outputs.tf` (qué expone a otros
módulos). Esto tiene dos ventajas concretas:

1. **Reutilización**: el módulo `vpc` se podría usar en otro proyecto
   sin cambiar una línea.
2. **Lectura**: cualquiera que abra el repo entiende la arquitectura
   mirando `main.tf` (11 líneas por módulo), sin tener que leer 200
   líneas de recursos sueltos.

## Buenas prácticas aplicadas

- **Nada de credenciales hardcodeadas**: `db_password` es una
  variable `sensitive`, se pasa por `terraform.tfvars` (gitignoreado)
  o por variable de entorno `TF_VAR_db_password`.
- **RDS nunca pública** (`publicly_accessible = false`), solo
  alcanzable desde el Security Group de la EC2, no desde una IP
  suelta ni mucho menos desde internet.
- **SSH restringido a una IP conocida**, nunca `0.0.0.0/0`.
- **`.gitignore` específico de Terraform**: el archivo de estado
  (`.tfstate`) nunca se sube a git, porque puede contener datos
  sensibles en texto plano.

## Requisitos

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
  >= 1.5.0
- Una cuenta de AWS con credenciales configuradas (`aws configure`)
- Un **key pair** de EC2 ya creado en tu cuenta (para SSH)

## Cómo desplegarlo

```bash
git clone https://github.com/BrunoCetrangolo/terraform-aws-infra.git
cd terraform-aws-infra

cp terraform.tfvars.example terraform.tfvars
# Editá terraform.tfvars con tu key_name, tu IP pública y una
# contraseña para la base de datos.

terraform init
terraform validate
terraform plan
terraform apply
```

Terraform te va a mostrar el plan completo antes de crear nada, y
pide confirmación (`yes`) antes de aplicar.

## ⚠️ Importante: esto genera costos reales en AWS

RDS y el NAT Gateway **no entran en la capa gratuita completa** (NAT
Gateway cobra por hora incluso sin tráfico). No lo dejes corriendo de
más — para probarlo, desplegalo, sacá captura de los outputs, y
destruilo:

```bash
terraform destroy
```

## Outputs

Al terminar el `apply`, Terraform muestra:

- `vpc_id` — ID de la VPC creada
- `ec2_public_ip` — IP pública para conectarte por SSH a la instancia
- `rds_endpoint` — endpoint de conexión a la base de datos

## Estructura

```
terraform-aws-infra/
├── main.tf                  # Llama a los 3 módulos
├── variables.tf              # Variables de toda la configuración
├── outputs.tf
├── terraform.tfvars.example  # Plantilla para tus valores reales
├── .gitignore
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── rds/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Próximos pasos (roadmap)

- Mover el state a un backend remoto (S3 + DynamoDB para locking),
  en vez del state local por defecto — necesario en cualquier equipo
  real donde más de una persona aplica cambios.
- Separar en workspaces o carpetas `environments/dev` y
  `environments/prod` con distintos `.tfvars` por ambiente.
- Sumar un Application Load Balancer delante de la EC2.

## Por qué este proyecto

Pensado como pieza de portfolio para roles DevOps/Cloud junior:
muestra una arquitectura de AWS realista (no solo "un bucket S3"),
organizada en módulos reutilizables, con el manejo de secretos y de
seguridad de red (subnets públicas/privadas, Security Groups en
capas) que se espera en un entorno de producción real.

# ---------------------------------
# FUNCIONES
# ---------------------------------

function ModificarDireccionIP {
    # Ruta al archivo .conf que deseas modificar
     $rutaArchivo = "C:\Users\vboxuser\Documents\acs.ini"

    # Lee el contenido del archivo
    $contenido = Get-Content $rutaArchivo

    # Define la expresión regular para buscar la dirección IP en el formato 'xxx.xxx.xxx.xxx'
    $patron = 'NTServer=(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'

    # Busca la línea que contiene la dirección IP usando la expresión regular
    $lineaAEditar = $contenido | Where-Object { $_ -match $patron }

    # Extrae la IP de la línea encontrada
    $ipActual = $matches[1]

    # Reemplaza la dirección IP con una nueva IP (por ejemplo, 192.168.1.100)
    $nuevaIP = Read-Host "Ingrese la nueva dirección IP del servidor"

    # Reemplaza la IP actual con la nueva IP en la línea
    $lineaModificada = $lineaAEditar -replace $ipActual, ($nuevaIP -split ' ')[-1]

    # Reemplaza la línea original en el contenido del archivo
    $contenido = $contenido -replace [regex]::Escape($lineaAEditar), $lineaModificada

    # Escribe el contenido modificado de vuelta al archivo
    $contenido | Set-Content $rutaArchivo

    Write-Host "La dirección IP del servidor ha sido modificada correctamente."
    Start-Sleep -Seconds 2
}



# Verificar si se está ejecutando como administrador

#$credenciales = Get-Credential -Message "Ingrese las credenciales de administrador"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Solicitar privilegios de administrador y volver a ejecutar el script
    Start-Process powershell.exe -Verb RunAs -ArgumentList ('-File', $MyInvocation.MyCommand.Path)
    exit
}


# -----------------------------------
# INICIANDO PROGRAMA
# -----------------------------------

do {
    Clear-Host

    # Solicitar al usuario que elija una opción
    Write-Host "Por favor, elija una opción:"
    Write-Host "1. Modificar la dirección IP del servidor"
    Write-Host "2. Salir"
    Write-Host "3. Env"
    write-host "4. simular entrada de texto"
    write-host "5. automatizar credenciales"
    write-host "6. modifcar acs"

    $opcion = Read-Host "Escribe el número de la opción y presiona Enter"

    # Verificar la opción seleccionada por el usuario
    switch ($opcion) {
        1 {
           ModificarDireccionIP
        }
        2 {
            Write-Host "Saliendo del programa."
        }
        3 {
            $usuarioActual = $env:USERNAME
            Write-Host "El usuario actualmente autenticado es: $usuarioActual"
            Start-Sleep -Seconds 5
        }
        4 {
$credenciales = Get-Credential
            Add-Type -AssemblyName System.Windows.Forms

# Especifica el texto que deseas enviar
$texto = "Texto a escribir en el input"

Write-Host "Presiona Enter para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Enfoca la ventana de la aplicación
#Start-Process -FilePath "ruta\al\ejecutable.exe" -PassThru | Wait-Process
#Start-Sleep -Seconds 3  # Espera 2 segundos para asegurarte de que la ventana esté lista
[System.Windows.Forms.SendKeys]::SendWait($texto)

        }
        5 {
            # Solicitar credenciales de administrador de forma segura
#$credenciales = Get-Credential -Message "Ingrese las credenciales de administrador"

# Ruta al ejecutable que deseas instalar
$rutaEjecutable = "C:\Users\vboxuser\Documents\ACSystem.msi"
#-Credential $credenciales

# Instalar el ejecutable utilizando las credenciales de administrador
#Start-Process -FilePath $rutaEjecutable -Wait
#ModificarDireccionIP
Move-Item -Path "C:\Users\vboxuser\Documents\acs.ini" -Destination "C:\Program Files (x86)\ACSystem\" -Force

        Write-Host "Presiona Enter para continuar..."
Read-Host

        }
        6 {
        # Ruta del archivo de configuración
$rutaArchivo = "C:\Users\vboxuser\Documents\acs.ini"

# Nueva IP que quieres usar
$nuevaIP = Read-Host "Ingrese la nueva dirección IP del servidor"

# Leer el contenido del archivo
$contenido = Get-Content -Path $rutaArchivo

# Buscar la línea que comienza con "NTServer="
$líneaAModificar = $contenido | Where-Object { $_ -match "^NTServer=" }

# Si encontramos una línea que comienza con "NTServer="
if ($líneaAModificar) {
    # Dividir la línea en dos partes en base al signo igual "="
    $partes = $líneaAModificar -split "="

    # Reemplazar la segunda parte (después del signo igual) con la nueva IP
    $partes[1] = $nuevaIP

    # Unir las partes nuevamente con el signo igual "="
    $nuevaLínea = $partes -join "="

    # Reemplazar la línea original con la línea modificada
    $contenido = $contenido -replace $líneaAModificar, $nuevaLínea

    # Escribir el contenido modificado de vuelta al archivo
    $contenido | Set-Content -Path $rutaArchivo
} else {
    Write-Host "No se encontró la línea 'NTServer=' en el archivo."
}

        Write-Host "Presiona Enter para continuar..."
Read-Host

        }
        7 {
        # Ruta del archivo al que deseas crear un acceso directo
$rutaArchivo = "C:\Program Files (x86)\ACSystem\ACSystem.exe"

# Ruta donde deseas que se guarde el acceso directo
$rutaAccesoDirecto = "C:\Users\vboxuser\Desktop\Acs.lnk"

# Crear un objeto Shell.Application COM
$objetoShell = New-Object -ComObject WScript.Shell

# Crear el acceso directo
$accesoDirecto = $objetoShell.CreateShortcut($rutaAccesoDirecto)

# Establecer la ruta de destino del acceso directo
$accesoDirecto.TargetPath = $rutaArchivo

# Guardar el acceso directo
$accesoDirecto.Save()

Write-Host "Acceso directo creado en $rutaAccesoDirecto"
# Crear un objeto Shell.Application COM
$objetoShell = New-Object -ComObject Shell.Application

# Obtener el objeto del acceso directo
$accesoDirecto = $objetoShell.NameSpace((Get-Item $rutaAccesoDirecto).DirectoryName).ParseName((Get-Item $rutaAccesoDirecto).Name)

# Anclar el acceso directo al taskbar
$objetoShell.Namespace("shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}").Self.InvokeVerbEx($accesoDirecto, "taskbarpin", $null)

Write-Host "Acceso directo anclado al taskbar."

        Write-Host "Presiona Enter para continuar..."
Read-Host

        }
        default {
            Write-Host "Opción no válida. Por favor, seleccione una opción válida."
            Start-Sleep -Seconds 2 # Espera 2 segundos antes de continuar
        }
    }
} while ($opcion -ne "2")



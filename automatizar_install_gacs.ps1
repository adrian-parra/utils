
# ---------------------------------
# FUNCIONES
# ---------------------------------

function ModificarDireccionIP {
    # Ruta al archivo .conf que deseas modificar
     $rutaArchivo = "C:\Users\vboxuser\Documents\l.conf"

    # Lee el contenido del archivo
    $contenido = Get-Content $rutaArchivo

    # Define la expresión regular para buscar la dirección IP en el formato 'xxx.xxx.xxx.xxx'
    $patron = 'server = (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'

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


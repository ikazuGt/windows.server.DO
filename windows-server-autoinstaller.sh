#!/bin/bash

# Function to display menu and get user choice
display_menu() {
    echo "Please select the Windows Server or Windows version:"
    echo "1. Windows Server 2016"
    echo "2. Windows Server 2019"
    echo "3. Windows Server 2022"
    echo "4. Windows 10"
    echo "5. Windows 11"
    echo "6. Windows 1021h2 (Note: This links to an IMG file)"
    read -p "Enter your choice: " choice
}

# --- OPTIMIZED QEMU INSTALLATION ---
# Update package repositories
echo "Updating package list..."
apt update -y

# Install only the necessary QEMU packages for KVM virtualization and utility:
# qemu-system-x86: The main emulator for x86/x64 architecture.
# qemu-utils: Provides the 'qemu-img' command used to create the disk image.
echo "Installing minimal QEMU packages for KVM..."
apt install qemu-system-x86 qemu-utils -y

echo "Minimal QEMU installation completed successfully."

# Get user choice
display_menu

case $choice in
    1)
        # Windows Server 2016 Evaluation (Official Microsoft Link)
        img_file="windows2016.img"
        iso_link="https://go.microsoft.com/fwlink/p/?LinkID=2195174&clcid=0x409&culture=en-us&country=US"
        iso_file="windows2016.iso"
        ;;
    2)
        # Windows Server 2019 Evaluation (Official Microsoft Link)
        img_file="windows2019.img"
        iso_link="https://go.microsoft.com/fwlink/p/?LinkID=2195167&clcid=0x409&culture=en-us&country=US"
        iso_file="windows2019.iso"
        ;;
    3)
        # Windows Server 2022 Evaluation (Official Microsoft Link)
        img_file="windows2022.img"
        iso_link="https://go.microsoft.com/fwlink/p/?LinkID=2195280&clcid=0x409&culture=en-us&country=US"
        iso_file="windows2022.iso"
        ;;
    4)
        # Windows 10 (Using provided non-official link - exercise caution)
        img_file="windows10.img"
        iso_link="https://software.download.prss.microsoft.com/dbazure/Win10_22H2_English_x64v1.iso?t=d1d0131d-41c8-40b7-a13d-26691852470d&P1=1764300906&P2=601&P3=2&P4=Br65xzyklxMSSK3HSCry8Mj3SH5SaDLe2DCNwfYpGkijYQ1Y6AThnyJekR6hVkYPktf9Inpir9DgmGtFGeVXBqWOBt665ae9%2bBTeq19ygq2MZGvJ7FGtIOSqbxY7wemyAtA65ABA%2bkjDvZYG2cYv8VjOnVE2W5Pu1PsnX5itNaNSM%2fe5mxUF4hFB%2fEpmpFMUo%2f%2fjOaROcMuPko%2fmd5cz75gC81G0z%2b9U%2fVObtfsGMcweeHx9o2nMAwcVm7Pre8W2c57PML4XmZmkceay2LzpPUvfjPh2%2f0PpaerjkHC02BFy9u3ZRsQm7W7CYl041xVXvCPghM5djcX8S%2beUM2nBeA%3d%3d"
        iso_file="windows10.iso"
        ;;
    5)
        # Windows 11 (Using provided non-official link - exercise caution)
        img_file="windows11.img"
        iso_link="http://152.53.194.161/WIN11.ISO"
        iso_file="windows11.iso"
        ;;
    6)
        # Windows 10 21H2 (Using provided non-official link, noted as .img source)
        img_file="windows1021h2.img"
        iso_link="http://152.53.194.161/win1021H2.img"
        iso_file="windows1021h2.img" # Changed extension to match source file
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "Selected version: $img_file"

# Create a raw disk image file (40GB)
qemu-img create -f raw "$img_file" 40G

echo "Disk image file $img_file created successfully."

# Download Virtio driver ISO (essential for disk/network on KVM)
wget -O virtio-win.iso 'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.215-1/virtio-win-0.1.215.iso'

echo "Virtio driver ISO downloaded successfully."

# Download Windows file
wget -O "$iso_file" "$iso_link"

echo "Windows image downloaded successfully as $iso_file."

# Note: The next step would be to run the QEMU command to start the installation
# (e.g., qemu-system-x86_64 -m 4G -hda "$img_file" -cdrom "$iso_file" -cdrom virtio-win.iso ...)

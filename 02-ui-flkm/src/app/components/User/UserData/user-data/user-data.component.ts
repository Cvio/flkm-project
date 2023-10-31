import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../../services/User/UserData/user-data.service';

import { createHelia } from 'helia';
const helia = await createHelia();

@Component({
  selector: 'app-user-data',
  templateUrl: './user-data.component.html',
  styleUrls: ['./user-data.component.css'],
})
export class UserDataComponent implements OnInit {
  selectedFile: File | null = null;

  constructor(private userService: UserService) {}

  ngOnInit(): void {}

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;

    if (input.files) {
      this.selectedFile = input.files[0];
    }
  }

  async uploadToIPFS(file: File): Promise<string> {
    try {
      const helia = await createHelia(); // Create a Helia instance
      // const added = await helia.add(file); // Add the file to IPFS
      // return added.path; // Return the CID
    } catch (error) {
      console.error('Error uploading to IPFS:', error);
      return '';
    }
  }

  async onSubmit(): Promise<void> {
    if (this.selectedFile) {
      // Upload the file to IPFS and mint the NFT
      const cid = await this.uploadToIPFS(this.selectedFile);

      if (cid) {
        // Mint the NFT
        this.userService.mintNFT(cid).then((result) => {
          if (result) {
            console.log('NFT minted successfully');
          } else {
            console.log('Failed to mint NFT');
          }
        });
      }
    }
  }
}

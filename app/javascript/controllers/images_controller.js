import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "preview", "image_box"]

  selectImages() {
    const files = this.selectTargets[0].files
    for (const file of files) {
      this.uploadImage(file)
    }
    this.selectTarget.value = ""
  }

  uploadImage(file) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    const formData = new FormData()
    formData.append("image", file)
    const options = {
      method: 'POST',
      headers: { 'X-CSRF-Token': csrfToken },
      body: formData
    }

    fetch("/items/upload_image", options)  // ここを修正
      .then(response => response.json())
      .then(data => {
        this.previewImage(file, data.id)
      })
      .catch((error) => {
        alert("画像のアップロード中にエラーが発生しました。")
        console.error(error)
      })
  }

  previewImage(file, id) {
    const preview = this.previewTarget
    const fileReader = new FileReader()
    const setAttr = (element, obj) => {
      Object.keys(obj).forEach(key => element.setAttribute(key, obj[key]))
    }

    fileReader.readAsDataURL(file)
    fileReader.onload = (function () {
      const img = new Image()
      const imgBox = document.createElement("div")
      const imgInnerBox = document.createElement("div")
      const deleteBtn = document.createElement("a")
      const hiddenField = document.createElement("input")

      const imgBoxAttr = {
        "class": "image-box inline-flex mx-1 mb-5",
        "data-controller": "images",
        "data-images-target": "image_box",
      }
      const imgInnerBoxAttr = { "class": "text-center" }
      const deleteBtnAttr = {
        "class": "link cursor-pointer",
        "data-action": "click->images#deleteImage"
      }
      const hiddenFieldAttr = {
        "name": "item[images][]",  // 修正済み
        "style": "none",
        "type": "hidden",
        "value": id,
      }

      setAttr(imgBox, imgBoxAttr)
      setAttr(imgInnerBox, imgInnerBoxAttr)
      setAttr(deleteBtn, deleteBtnAttr)
      setAttr(hiddenField, hiddenFieldAttr)

      deleteBtn.textContent = "削除"

      imgBox.appendChild(imgInnerBox)
      imgInnerBox.appendChild(img)
      imgInnerBox.appendChild(deleteBtn)
      imgInnerBox.appendChild(hiddenField)
      img.src = this.result
      img.width = 100

      preview.appendChild(imgBox)
    })
  }

  deleteImage() {
    this.image_boxTarget.remove()
  }
}

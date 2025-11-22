import { useEffect, useState } from 'react'
import { supabase } from '../config/supabase'
import { Card } from '../components/ui/Card'
import { Button } from '../components/ui/Button'
import { Input } from '../components/ui/Input'
import { Modal } from '../components/ui/Modal'
import { Loading } from '../components/ui/Loading'
import { Alert } from '../components/ui/Alert'
import { Plus, Edit, Trash2 } from 'lucide-react'

export default function Categories() {
  const [categories, setCategories] = useState([])
  const [loading, setLoading] = useState(true)
  const [modalOpen, setModalOpen] = useState(false)
  const [editingCategory, setEditingCategory] = useState(null)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    color: '#3B82F6'
  })

  const colors = [
    '#3B82F6', '#8B5CF6', '#10B981', '#EF4444', 
    '#F59E0B', '#06B6D4', '#EC4899', '#14B8A6'
  ]

  useEffect(() => {
    fetchCategories()
  }, [])

  const fetchCategories = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false })
      
      if (error) throw error
      setCategories(data || [])
    } catch (error) {
      console.error('Error fetching categories:', error)
      setError('Failed to load categories')
    } finally {
      setLoading(false)
    }
  }

  const handleOpenModal = (category = null) => {
    if (category) {
      setEditingCategory(category)
      setFormData({
        name: category.name,
        description: category.description || '',
        color: category.color || '#3B82F6'
      })
    } else {
      setEditingCategory(null)
      setFormData({
        name: '',
        description: '',
        color: '#3B82F6'
      })
    }
    setModalOpen(true)
  }

  const handleCloseModal = () => {
    setModalOpen(false)
    setEditingCategory(null)
    setError('')
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    
    try {
      const { data: { user } } = await supabase.auth.getUser()
      
      if (editingCategory) {
        const { error: updateError } = await supabase
          .from('categories')
          .update(formData)
          .eq('id', editingCategory.id)
          .eq('user_id', user.id)
        
        if (updateError) throw updateError
        setSuccess('Category updated successfully!')
      } else {
        const { error: insertError } = await supabase
          .from('categories')
          .insert([{
            ...formData,
            user_id: user.id
          }])
        
        if (insertError) throw insertError
        setSuccess('Category created successfully!')
      }
      
      handleCloseModal()
      fetchCategories()
      setTimeout(() => setSuccess(''), 3000)
    } catch (error) {
      console.error('Error saving category:', error)
      setError(error.message || 'Failed to save category')
    }
  }

  const handleDelete = async (categoryId) => {
    if (!confirm('Are you sure you want to delete this category?')) return
    
    try {
      const { data: { user } } = await supabase.auth.getUser()
      
      const { error: deleteError } = await supabase
        .from('categories')
        .delete()
        .eq('id', categoryId)
        .eq('user_id', user.id)
      
      if (deleteError) throw deleteError
      
      setSuccess('Category deleted successfully!')
      fetchCategories()
      setTimeout(() => setSuccess(''), 3000)
    } catch (error) {
      console.error('Error deleting category:', error)
      setError('Failed to delete category')
    }
  }

  if (loading) return <Loading size="lg" />

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-4xl font-black uppercase">Categories</h1>
        <Button variant="primary" onClick={() => handleOpenModal()}>
          <Plus size={20} className="mr-2" />
          Add Category
        </Button>
      </div>

      {error && <Alert variant="danger" onClose={() => setError('')}>{error}</Alert>}
      {success && <Alert variant="success" onClose={() => setSuccess('')}>{success}</Alert>}

      {/* Categories Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {categories.length === 0 ? (
          <Card className="col-span-full bg-white">
            <p className="text-center font-bold text-gray-500 py-8">No categories yet</p>
          </Card>
        ) : (
          categories.map((category) => (
            <Card key={category.id} className="bg-white">
              <div 
                className="w-full h-3 mb-4 border-2 border-black"
                style={{ backgroundColor: category.color }}
              />
              <h3 className="text-xl font-bold mb-2">{category.name}</h3>
              <p className="text-gray-600 mb-4">{category.description || 'No description'}</p>
              <div className="flex gap-2">
                <Button 
                  variant="primary" 
                  onClick={() => handleOpenModal(category)}
                  className="flex-1"
                >
                  <Edit size={16} className="mr-2" />
                  Edit
                </Button>
                <Button 
                  variant="danger" 
                  onClick={() => handleDelete(category.id)}
                  className="flex-1"
                >
                  <Trash2 size={16} className="mr-2" />
                  Delete
                </Button>
              </div>
            </Card>
          ))
        )}
      </div>

      {/* Category Modal */}
      <Modal
        isOpen={modalOpen}
        onClose={handleCloseModal}
        title={editingCategory ? 'Edit Category' : 'Add New Category'}
        footer={
          <>
            <Button variant="default" onClick={handleCloseModal}>
              Cancel
            </Button>
            <Button variant="primary" onClick={handleSubmit}>
              {editingCategory ? 'Update' : 'Create'}
            </Button>
          </>
        }
      >
        <form onSubmit={handleSubmit}>
          <Input
            label="Category Name"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            required
          />
          
          <Input
            label="Description"
            value={formData.description}
            onChange={(e) => setFormData({ ...formData, description: e.target.value })}
          />

          <div className="mb-4">
            <label className="block mb-2 font-bold text-sm uppercase">Color</label>
            <div className="flex gap-3 flex-wrap">
              {colors.map((color) => (
                <button
                  key={color}
                  type="button"
                  onClick={() => setFormData({ ...formData, color })}
                  className={`w-12 h-12 border-3 border-black transition-transform ${
                    formData.color === color ? 'scale-110 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]' : ''
                  }`}
                  style={{ backgroundColor: color }}
                />
              ))}
            </div>
          </div>
        </form>
      </Modal>
    </div>
  )
}
